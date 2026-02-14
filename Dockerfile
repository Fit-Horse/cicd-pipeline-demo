# ============================================
# CI/CD Pipeline Demo - Dockerfile
# 基于 Node.js Alpine 镜像的最小化 Docker 配置
# ============================================

# 阶段 1: 构建依赖
FROM node:18-alpine AS builder

# 设置工作目录
WORKDIR /usr/src/app

# 先复制 package.json 和 package-lock.json
# 利用 Docker 层缓存，加速依赖安装
COPY package*.json ./

# 安装生产依赖
RUN npm ci --only=production

# 阶段 2: 生产镜像
FROM node:18-alpine

# 设置工作目录
WORKDIR /usr/src/app

# 创建非 root 用户，提高安全性
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# 先复制 package.json（用于依赖安装）
COPY package*.json ./

# 安装生产依赖
RUN npm ci --only=production

# 复制构建好的依赖
COPY --from=builder /usr/src/app/node_modules ./node_modules

# 复制应用源代码
COPY . .

# 切换到非 root 用户
USER nodejs

# 暴露端口
EXPOSE 3000

# 启动命令
CMD ["node", "server.js"]
