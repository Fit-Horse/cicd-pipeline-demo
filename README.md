---
AIGC:
    ContentProducer: Minimax Agent AI
    ContentPropagator: Minimax Agent AI
    Label: AIGC
    ProduceID: "00000000000000000000000000000000"
    PropagateID: "00000000000000000000000000000000"
    ReservedCode1: 3046022100d0f65d3a50b7c628bad54ebb62b470ce821cb69cf9b8da1ad7818cdf353ec13c022100d7ce1e53036c67623918582ae631bd47c6fdd9a099d75886a264ffed73e8dc6d
    ReservedCode2: 304402200ae4ef0c2c210656a523ac9e3c41be293e4a261e3a68c3ed240cc39bfd1620e802201fe0cd6cea271c378c052c801fa178090492d3d10b418bbecacddb700e75128e
---

# CI/CD Pipeline Demo

[![CI/CD Pipeline](https://github.com/your-username/cicd-pipeline-demo/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/your-username/cicd-pipeline-demo/actions/workflows/ci-cd.yml)
[![Node.js](https://img.shields.io/badge/Node.js-18+-green.svg)](https://nodejs.org/)
[![Docker](https://img.shields.io/badge/Docker-20+-blue.svg)](https://www.docker.com/)

这是一个完整的 **GitHub Actions + Docker CI/CD 流程** 演示项目。通过这个项目，你可以学习到：

- 如何使用 Node.js + Express 构建 Web 应用
- 如何使用 Docker 容器化应用
- 如何配置 GitHub Actions 自动化 CI/CD 流程
- 如何编写和运行单元测试

## 目录

- [项目结构](#项目结构)
- [前置要求](#前置要求)
- [快速开始](#快速开始)
  - [本地开发](#本地开发)
  - [Docker 运行](#docker-运行)
- [CI/CD 流程说明](#cicd-流程说明)
- [GitHub Actions 配置详解](#github-actions-配置详解)
- [测试流程](#测试流程)
- [常见问题](#常见问题)

## 项目结构

```
cicd-pipeline-demo/
├── .github/
│   └── workflows/
│       └── ci-cd.yml      # GitHub Actions 工作流配置
├── test/
│   └── app.test.js        # 单元测试文件
├── Dockerfile             # Docker 镜像构建配置
├── docker-compose.yml     # Docker Compose 配置
├── package.json           # Node.js 依赖配置
├── server.js              # 应用主文件
└── README.md              # 项目说明文档
```

## 前置要求

在开始之前，你需要安装以下软件：

| 软件 | 版本要求 | 安装说明 |
|------|----------|----------|
| Node.js | 18+ | [官网下载](https://nodejs.org/) |
| Docker | 20+ | [官网下载](https://www.docker.com/) |
| Git | 任意 | 通常已预装 |

## 快速开始

### 本地开发

**步骤 1: 克隆项目**

```bash
git clone https://github.com/your-username/cicd-pipeline-demo.git
cd cicd-pipeline-demo
```

**步骤 2: 安装依赖**

```bash
npm install
```

**步骤 3: 启动应用**

```bash
npm start
```

应用启动后，访问以下地址：

- 主页: http://localhost:3000
- 健康检查: http://localhost:3000/health

**步骤 4: 运行测试**

```bash
npm test
```

测试通过后会显示如下输出：

```
PASS  test/app.test.js
  CI/CD Demo 应用测试
    ✓ 根路由应返回 200 状态码
    ✓ 根路由应返回 HTML 内容
    ✓ 健康检查端点应返回 active 状态
    ✓ 健康检查端点应返回完整的 JSON 结构
    ✓ 不存在的路由应返回 404

Tests:       5 passed, 5 total
Tests:       5 passed, 100% coverage
```

### Docker 运行

**方式一: 使用 Docker Compose (推荐)**

```bash
# 构建并启动容器
docker-compose up --build

# 后台运行
docker-compose up -d --build

# 查看日志
docker-compose logs -f

# 停止容器
docker-compose down
```

**方式二: 使用 Docker 命令**

```bash
# 构建镜像
docker build -t cicd-pipeline-demo .

# 运行容器
docker run -p 3000:3000 cicd-pipeline-demo

# 后台运行
docker run -d -p 3000:3000 --name my-app cicd-pipeline-demo
```

容器启动后，访问 http://localhost:3000 查看应用。

## CI/CD 流程说明

### 流程概览

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   代码推送   │────▶│   CI 阶段    │────▶│   CD 阶段    │────▶│ Docker Hub  │
│  (Push)     │     │  (测试)      │     │  (构建镜像)  │     │  (自动推送)  │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
```

### 触发条件

工作流会在以下情况自动触发：

1. **推送到 main 分支**: 代码合并到主分支时触发完整流程
2. **创建 Pull Request**: 向 main 分支提交 PR 时触发 CI 流程
3. **手动触发**: 可以通过 GitHub Actions 页面手动运行

### 工作流阶段

#### 阶段 1: 持续集成 (CI)

1. **检出代码**: 下载仓库代码
2. **设置 Node.js**: 配置 Node.js 18 环境
3. **安装依赖**: 使用 `npm ci` 安装项目依赖
4. **运行测试**: 执行单元测试，验证代码正确性
5. **生成报告**: 保存测试覆盖率报告

#### 阶段 2: 持续交付 (CD)

仅在 CI 阶段成功后执行：

1. **设置 Docker Buildx**: 配置 Docker 构建环境
2. **构建镜像**: 使用 Dockerfile 构建 Docker 镜像
3. **验证镜像**: 验证镜像构建成功

## GitHub Actions 配置详解

### Docker Hub 自动推送配置

本项目已配置完整的 Docker Hub 自动推送功能。当代码推送到 main 分支并通过所有测试后，Docker 镜像会自动构建并推送到你的 Docker Hub 仓库。

#### 步骤 1: 获取 Docker Hub 凭证

1. 登录 [Docker Hub](https://hub.docker.com/)
2. 点击右上角用户名 → **Account Settings**
3. 选择 **Security** → 点击 **New Access Token**
4. 填写 Token 描述（如 "github-actions-cicd"）
5. 选择 Token 权限为 **Read, Write, Delete**
6. 点击 **Create** 并保存生成的 Token 值（只会显示一次，请妥善保存）

#### 步骤 2: 在 GitHub 仓库中添加 Secrets

1. 打开你的 GitHub 仓库页面
2. 进入 **Settings** → **Secrets and variables** → **Actions**
3. 点击 **New repository secret** 按钮
4. 添加以下两个 Secret：

| Secret 名称 | 值 | 说明 |
|-------------|-----|------|
| `DOCKER_USERNAME` | 你的 Docker Hub 用户名 | 用于登录 Docker Hub |
| `DOCKER_PASSWORD` | 刚才创建的 Access Token | Docker Hub 访问令牌 |

**重要提示**：不要直接在 workflow 文件中硬编码用户名和密码，必须使用 GitHub Secrets 来保护你的凭证安全。

#### 步骤 3: 修改镜像名称（可选）

在 `.github/workflows/ci-cd.yml` 文件中，找到以下行：

```yaml
IMAGE_NAME: ${{ secrets.DOCKER_USERNAME }}/cicd-pipeline-demo
```

将其修改为你想要的镜像名称：

```yaml
IMAGE_NAME: ${{ secrets.DOCKER_USERNAME }}/你的镜像名
```

#### 步骤 4: 推送代码触发自动构建

完成上述配置后，每次推送到 main 分支都会自动：

1. 运行单元测试
2. 构建 Docker 镜像
3. 登录 Docker Hub
4. 推送镜像到 Docker Hub

你可以在 Docker Hub 上查看已推送的镜像：

```
https://hub.docker.com/r/你的用户名/cicd-pipeline-demo
```

#### 步骤 5: 使用版本标签发布（可选）

当你推送 Git Tag 时，工作流会自动为镜像添加对应版本标签。例如：

```bash
# 创建一个版本标签
git tag v1.0.0

# 推送到远程仓库
git push origin v1.0.0
```

这会自动为镜像添加以下标签：

- `latest`：最新版本
- `1.0.0`：完整版本号
- `1.0`：主版本和次版本
- `1`：主版本

### 工作流文件结构

`.github/workflows/ci-cd.yml` 文件包含以下关键配置：

```yaml
# 触发条件
on:
  push:
    branches: [main]      # 推送到 main 分支时触发
  pull_request:
    branches: [main]      # PR 时触发 CI

# 环境变量
env:
  NODE_VERSION: '18'      # Node.js 版本
  IMAGE_NAME: cicd-pipeline-demo

# 任务定义
jobs:
  ci:                     # CI 任务
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npm test

  build-docker:           # CD 任务
    needs: ci             # 依赖 CI 任务
    if: github.event_name == 'push'
```

### 如何在 GitHub 上配置

**步骤 1: 创建 GitHub 仓库**

1. 登录 GitHub
2. 创建新仓库: `cicd-pipeline-demo`
3. 将本地代码推送到仓库

```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/your-username/cicd-pipeline-demo.git
git push -u origin main
```

**步骤 2: 查看 Actions 执行结果**

1. 打开仓库页面
2. 点击 "Actions" 标签
3. 查看工作流执行状态
4. 点击具体运行查看详细日志

**步骤 3: (可选) 配置 Docker Hub 推送**

如果需要将镜像推送到 Docker Hub：

1. 在 GitHub 仓库设置中添加 Secrets:
   - `DOCKER_USERNAME`: Docker Hub 用户名
   - `DOCKER_PASSWORD`: Docker Hub 密码

2. 修改 workflow 文件，添加推送步骤

## 测试流程

### 本地测试

```bash
# 安装依赖后运行测试
npm test

# 查看测试覆盖率
npm test -- --coverage
```

### GitHub Actions 自动测试

每次推送代码后，GitHub Actions 会自动：

1. 拉取最新代码
2. 安装依赖
3. 运行测试套件
4. 生成测试报告

你可以在 Actions 页面查看测试结果。

### 模拟失败场景

为了验证 CI 流程正常工作，可以故意引入错误：

**步骤 1: 修改测试文件**

打开 `test/app.test.js`，将某个测试的预期值改为错误值：

```javascript
// 修改前
expect(response.status).toBe(200);

// 修改后
expect(response.status).toBe(500);  // 故意错误
```

**步骤 2: 推送代码**

```bash
git add .
git commit -m "Intentional test failure"
git push origin main
```

**步骤 3: 查看失败结果**

1. 打开 GitHub -> Actions
2. 看到 CI 失败 (红色 X)
3. 查看失败原因
4. 修复后重新推送

## 常见问题

### Q1: Docker 构建失败怎么办？

检查以下几点：
- Docker 是否已正确安装并运行
- 端口 3000 是否已被占用
- 是否有足够的磁盘空间

### Q2: GitHub Actions 超时怎么办？

- 检查网络连接
- 查看是否有语法错误
- 确认仓库是否为公开仓库（私有仓库有免费分钟限制）

### Q3: 如何修改端口号？

1. 修改 `server.js` 中的 PORT 默认值
2. 修改 `docker-compose.yml` 中的端口映射
3. 修改 Dockerfile 中的 EXPOSE 指令

### Q4: 如何添加更多测试？

在 `test/app.test.js` 中添加新的测试用例：

```javascript
test('描述测试内容', async () => {
  const response = await request(app).get('/your-route');
  expect(response.status).toBe(200);
});
```

## 扩展阅读

- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [Docker 文档](https://docs.docker.com/)
- [Node.js 文档](https://nodejs.org/docs/)
- [Jest 测试框架](https://jestjs.io/docs/)

## 许可证

MIT License - 欢迎自由使用和修改！

---

**祝你学习愉快！** 🎉
