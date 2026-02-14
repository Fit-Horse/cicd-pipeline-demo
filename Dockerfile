# ============================================
# CI/CD Pipeline Demo - Dockerfile
# 基于 Node.js Alpine 镜像的最小化 Docker 配置
# ============================================

# 阶段 1: 构建依赖
FROM node:18-alpine

# 安装生产依赖
RUN npm install --only=production

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
