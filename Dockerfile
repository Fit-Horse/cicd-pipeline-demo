# ============================================
# CI/CD Pipeline Demo - Dockerfile
# 基于 Node.js Alpine 镜像的最小化 Docker 配置
# ============================================

FROM node:18-alpine

WORKDIR /usr/src/app

# 先复制依赖文件，利用层缓存
COPY package*.json ./

# 安装生产依赖：关闭 audit/fund，避免在 CI 中因网络或权限导致 exit 255
ENV NODE_ENV=production
ENV npm_config_audit=false
ENV npm_config_fund=false
RUN npm install --omit=dev

# 复制应用源代码
COPY . .

# 切换到非 root 用户 (Alpine 中该用户名为 node)
USER node

# 暴露端口
EXPOSE 3000

# 启动命令
CMD ["node", "server.js"]
