/**
 * 应用单元测试
 * 使用 Jest 和 Supertest 进行 API 端点测试
 */

const request = require('supertest');
const app = require('../server');

describe('CI/CD Demo 应用测试', () => {
  /**
   * 测试根路由返回 200 状态码
   */
  test('根路由应返回 200 状态码', async () => {
    const response = await request(app).get('/');
    expect(response.status).toBe(200);
  });

  /**
   * 测试根路由返回 HTML 内容
   */
  test('根路由应返回 HTML 内容', async () => {
    const response = await request(app).get('/');
    expect(response.type).toBe('text/html');
    expect(response.text).toContain('CI/CD Pipeline Demo');
  });

  /**
   * 测试健康检查端点返回正确状态
   */
  test('健康检查端点应返回 active 状态', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.type).toBe('application/json');
    expect(response.body).toHaveProperty('status', 'active');
    expect(response.body).toHaveProperty('timestamp');
    expect(response.body).toHaveProperty('uptime');
  });

  /**
   * 测试健康检查端点返回完整的 JSON 结构
   */
  test('健康检查端点应返回完整的 JSON 结构', async () => {
    const response = await request(app).get('/health');
    const body = response.body;

    // 验证必需字段存在
    expect(body).toHaveProperty('status');
    expect(body).toHaveProperty('timestamp');
    expect(body).toHaveProperty('uptime');
    expect(body).toHaveProperty('message');

    // 验证字段类型
    expect(typeof body.status).toBe('string');
    expect(typeof body.timestamp).toBe('string');
    expect(typeof body.uptime).toBe('number');
  });

  /**
   * 测试不存在的路由返回 404
   */
  test('不存在的路由应返回 404', async () => {
    const response = await request(app).get('/nonexistent');
    expect(response.status).toBe(404);
  });
});
