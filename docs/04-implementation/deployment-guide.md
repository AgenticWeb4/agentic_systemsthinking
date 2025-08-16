# 部署指南

## 概述

本文档提供了系统思维智能体项目的部署指南，包括环境配置、容器化部署、监控配置等内容。

## 部署环境

### 环境分类
- **开发环境 (Development)**: 本地开发使用
- **测试环境 (Testing)**: 功能测试和集成测试
- **生产环境 (Production)**: 正式运行环境

### 环境要求
- 操作系统: Linux (推荐Ubuntu 20.04+)
- Docker: 20.10+
- Docker Compose: 2.0+
- 内存: 最少8GB，推荐16GB+
- 存储: 最少50GB可用空间
- 网络: 稳定的网络连接

## 环境配置

### 环境变量配置
1. 复制环境配置文件模板
2. 修改数据库连接信息
3. 配置服务端口
4. 设置日志级别
5. 配置安全参数

### 配置文件示例
```bash
# 数据库配置
POSTGRES_DB=mydb
POSTGRES_USER=postgres
POSTGRES_PASSWORD=secure_password
POSTGRES_HOST=localhost
POSTGRES_PORT=5432

# 服务端口
GUI_PORT=3000
RUST_BACKEND_PORT=8001
JAVA_BACKEND_PORT=8002
AGENT_SYSTEM_PORT=8003

# 日志配置
LOG_LEVEL=INFO
LOG_FILE=/var/log/agentic-systemthinking.log
```

## 容器化部署

### Docker部署
1. 构建Docker镜像
2. 配置Docker Compose
3. 启动服务容器
4. 验证服务状态

### 部署命令
```bash
# 构建所有服务
make build

# 启动开发环境
make dev

# 启动生产环境
docker-compose -f docker/prod/docker-compose.yml up -d

# 查看服务状态
make status

# 查看服务日志
make logs
```

### 服务编排
- PostgreSQL数据库服务
- Redis缓存服务
- Rust后端服务
- Java后端服务
- 智能体系统服务
- GUI前端服务

## 数据库部署

### PostgreSQL部署
1. 创建数据库实例
2. 运行初始化脚本
3. 配置连接参数
4. 设置备份策略

### 数据库初始化
```sql
-- 创建数据库
CREATE DATABASE mydb;

-- 运行初始化脚本
\i /docker-entrypoint-initdb.d/init.sql

-- 验证表结构
\dt
```

## 监控配置

### 健康检查
- 服务健康状态监控
- 数据库连接监控
- 服务间通信监控
- 资源使用监控

### 日志管理
- 集中日志收集
- 日志轮转配置
- 错误日志告警
- 日志分析工具

### 性能监控
- CPU和内存使用率
- 网络流量监控
- 数据库性能监控
- 响应时间监控

## 安全配置

### 网络安全
- 防火墙配置
- 端口访问控制
- SSL/TLS证书配置
- 反向代理设置

### 数据安全
- 数据库访问控制
- 敏感信息加密
- 备份数据加密
- 审计日志记录

## 备份和恢复

### 备份策略
- 数据库定期备份
- 配置文件备份
- 代码版本备份
- 环境配置备份

### 恢复流程
1. 停止相关服务
2. 恢复数据库备份
3. 恢复配置文件
4. 重启服务
5. 验证服务状态

## 故障排除

### 常见问题
- 服务启动失败
- 数据库连接失败
- 服务间通信失败
- 性能问题排查

### 排查步骤
1. 检查服务状态
2. 查看错误日志
3. 验证配置正确性
4. 检查网络连接
5. 验证资源使用

## 维护说明

- 文档版本: 1.0.0
- 最后更新: 2024年12月
- 维护团队: 系统工程开发团队
