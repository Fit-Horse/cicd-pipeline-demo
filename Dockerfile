# ============================================
# CI/CD Pipeline Demo - Dockerfile
# 基于 Node.js Alpine 镜像的最小化 Docker 配置
# ============================================

# 阶段 1: 构建依赖 (必须命名以便 COPY --from= 引用)
FROM node:18-alpine AS builder

WORKDIR /usr/src/app

# 先复制依赖文件，利用层缓存
COPY package*.json ./

# 安装生产依赖
RUN npm install --only=production

# 阶段 2: 运行镜像
FROM node:18-alpine

WORKDIR /usr/src/app

# 从 builder 阶段复制已安装的 node_modules
COPY --from=builder /usr/src/app/node_modules ./node_modules

# 复制应用源代码
COPY . .

# 切换到非 root 用户 (Alpine 中该用户名为 node)
USER node

# 暴露端口
EXPOSE 3000

# 启动命令
CMD ["node", "server.js"]
