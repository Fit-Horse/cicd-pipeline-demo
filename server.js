/**
 * CI/CD Pipeline Demo - Express 服务器
 * 这是一个简单的 Node.js + Express 应用，用于演示完整的 CI/CD 流程
 */

const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// 记录服务器启动时间
const serverStartTime = new Date();

/**
 * 根路由 - 返回主页 HTML
 */
app.get('/', (req, res) => {
  const currentTime = new Date();
  const uptime = Math.floor((currentTime - serverStartTime) / 1000);

  const html = `
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CI/CD Pipeline Demo</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      font-family: 'Courier New', Consolas, monospace;
      background: #f0f2f5;
      color: #1a1a1a;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
    }
    .container {
      background: white;
      padding: 3rem;
      border-radius: 12px;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
      max-width: 600px;
      width: 90%;
    }
    h1 {
      color: #2563eb;
      margin-bottom: 1.5rem;
      font-size: 1.8rem;
      text-align: center;
    }
    .info-item {
      margin: 1rem 0;
      padding: 0.8rem;
      background: #f8fafc;
      border-radius: 6px;
      border-left: 4px solid #2563eb;
    }
    .info-label {
      font-weight: bold;
      color: #64748b;
      font-size: 0.85rem;
      margin-bottom: 0.3rem;
    }
    .info-value {
      font-size: 1.1rem;
      color: #1e293b;
    }
    .status-badge {
      display: inline-block;
      padding: 0.3rem 0.8rem;
      background: #22c55e;
      color: white;
      border-radius: 20px;
      font-size: 0.85rem;
      margin-top: 0.5rem;
    }
    footer {
      margin-top: 2rem;
      text-align: center;
      color: #94a3b8;
      font-size: 0.85rem;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>🚀 CI/CD Pipeline Demo</h1>

    <div class="info-item">
      <div class="info-label">服务器运行时间</div>
      <div class="info-value">${uptime} 秒</div>
    </div>

    <div class="info-item">
      <div class="info-label">当前时间</div>
      <div class="info-value">${currentTime.toLocaleString('zh-CN')}</div>
    </div>

    <div class="info-item">
      <div class="info-label">系统状态</div>
      <div class="info-value">
        <span class="status-badge">正常运行中</span>
      </div>
    </div>

    <div class="info-item">
      <div class="info-label">健康检查端点</div>
      <div class="info-value">/health</div>
    </div>
  </div>

  <footer>
    Powered by GitHub Actions & Docker
  </footer>
</body>
</html>
  `;

  res.send(html);
});

/**
 * 健康检查路由 - 返回 JSON 格式的状态信息
 * 用于 Docker 容器健康检查和负载均衡器探测
 */
app.get('/health', (req, res) => {
  res.json({
    status: 'active',
    timestamp: new Date().toISOString(),
    uptime: Math.floor((new Date() - serverStartTime) / 1000),
    message: '服务运行正常'
  });
});

// 启动服务器 (仅在非测试环境下自动启动)
let server;

if (process.env.NODE_ENV !== 'test') {
  server = app.listen(PORT, () => {
    console.log(`🚀 CI/CD Demo 应用已启动`);
    console.log(`📍 访问地址: http://localhost:${PORT}`);
    console.log(`❤️  健康检查: http://localhost:${PORT}/health`);
  });
}

module.exports = app;
