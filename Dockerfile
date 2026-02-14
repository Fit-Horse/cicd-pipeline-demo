# ============================================
# CI/CD Pipeline Demo - Dockerfile
# 使用 Debian slim 基础镜像（Alpine 在 GitHub Actions 多平台构建/QEMU 下 npm 易报 255）
# ============================================

FROM node:18-slim

WORKDIR /usr/src/app

# 先复制依赖文件，利用层缓存
COPY package*.json ./

# 安装生产依赖
ENV NODE_ENV=production
ENV npm_config_audit=false
ENV npm_config_fund=false
RUN npm install --omit=dev

# 复制应用源代码
COPY . .

# 切换到非 root 用户
USER node

# 暴露端口
EXPOSE 3000

# 启动命令
CMD ["node", "server.js"]
