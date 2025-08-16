# Rust后端服务

系统思维智能体项目的高性能Rust后端服务。

## 技术栈

- **编程语言**: Rust 1.70+
- **Web框架**: Actix-web 4.4
- **异步运行时**: Tokio 1.0
- **数据库**: PostgreSQL + SQLx
- **日志**: env_logger + log

## 功能特性

- 服务健康检查
- 数据库健康检查
- 服务间通信
- 高性能异步处理

## 开发环境

### 环境要求
- Rust 1.70+
- PostgreSQL 15.0
- Docker (可选)

### 安装依赖
```bash
cargo build
```

### 开发模式
```bash
cargo run
```

### 测试
```bash
cargo test
```

## 项目结构

```
backend-rust/
├── src/                    # 源代码
│   ├── main.rs            # 主程序入口
│   ├── handlers/          # 请求处理器
│   ├── models/            # 数据模型
│   └── services/          # 业务服务
├── Cargo.toml             # Rust依赖配置
└── Dockerfile             # Docker构建文件
```

## API端点

- `GET /health` - 服务健康检查
- `GET /db-health` - 数据库健康检查
- `GET /check-services` - 检查其他服务状态

## 环境变量

- `DATABASE_URL` - 数据库连接URL
- `RUST_LOG` - 日志级别

## 部署

支持Docker容器化部署，详见Docker配置文件。

---

**维护团队**: 系统工程开发团队  
**最后更新**: 2024年12月
