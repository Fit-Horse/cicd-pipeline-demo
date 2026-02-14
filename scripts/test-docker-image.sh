#!/usr/bin/env bash
# ============================================
# 测试已推送到 Docker Hub 的镜像是否正常运行
# 用法: ./scripts/test-docker-image.sh [镜像名]
# 示例: ./scripts/test-docker-image.sh yourname/cicd-pipeline-demo:main
# ============================================

set -e

IMAGE_NAME="${1:-${DOCKER_IMAGE:-}}"
CONTAINER_NAME="cicd-demo-test-$$"
PORT=3000
# 若镜像仅有 amd64（如 CI 未构建 arm64），在 Apple Silicon 上可设: DOCKER_PLATFORM=linux/amd64
PLATFORM_ARGS=()
[ -n "${DOCKER_PLATFORM:-}" ] && PLATFORM_ARGS=(--platform "$DOCKER_PLATFORM")

if [ -z "$IMAGE_NAME" ]; then
  echo "用法: $0 <镜像名>"
  echo "示例: $0 yourname/cicd-pipeline-demo:main"
  echo "或设置环境变量: DOCKER_IMAGE=yourname/cicd-pipeline-demo:main $0"
  exit 1
fi

echo "============================================"
echo "测试 Docker 镜像: $IMAGE_NAME"
echo "============================================"

# 清理：若已有同名容器则先删除
docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

echo ""
echo "1. 拉取镜像..."
docker pull "${PLATFORM_ARGS[@]}" "$IMAGE_NAME"

echo ""
echo "2. 启动容器 (端口 $PORT)..."
docker run -d --name "$CONTAINER_NAME" -p "$PORT:3000" "${PLATFORM_ARGS[@]}" "$IMAGE_NAME"

# 等待服务就绪
echo ""
echo "3. 等待服务启动..."
for i in $(seq 1 15); do
  if curl -s -o /dev/null -w "%{http_code}" "http://localhost:$PORT/health" 2>/dev/null | grep -q 200; then
    echo "   服务已就绪 (${i}s)"
    break
  fi
  if [ "$i" -eq 15 ]; then
    echo "错误: 服务在 15 秒内未响应"
    docker logs "$CONTAINER_NAME"
    docker rm -f "$CONTAINER_NAME" 2>/dev/null || true
    exit 1
  fi
  sleep 1
done

echo ""
echo "4. 检查接口..."

# 测试 /health
HEALTH_RESPONSE=$(curl -s "http://localhost:$PORT/health")
if echo "$HEALTH_RESPONSE" | grep -q '"status":"active"'; then
  echo "   ✅ /health 返回正常"
else
  echo "   ❌ /health 响应异常: $HEALTH_RESPONSE"
  docker rm -f "$CONTAINER_NAME" 2>/dev/null || true
  exit 1
fi

# 测试 /
HOME_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:$PORT/")
if [ "$HOME_STATUS" = "200" ]; then
  echo "   ✅ / 返回 200"
else
  echo "   ❌ / 返回 $HOME_STATUS (期望 200)"
  docker rm -f "$CONTAINER_NAME" 2>/dev/null || true
  exit 1
fi

echo ""
echo "5. 停止并删除测试容器..."
docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

echo ""
echo "============================================"
echo "✅ 镜像测试通过: $IMAGE_NAME"
echo "============================================"
