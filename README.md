# 系统思维智能体项目 - 多智能体协作系统

一个基于多技术栈的智能体协作系统项目，采用 Monorepo 架构，支持 Python、Java 智能体的独立开发和协同工作。通过 Redis 消息中间件实现智能体间的异步协作，编排服务提供统一的协调和负载均衡。

## 🏗️ 项目架构

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   GUI 应用      │    │   Rust 后端     │    │   Java 后端     │
│   (Tauri+Svelte)│    │   (Actix-web)   │    │   (Spring Boot) │
│   Port: 3000    │    │   Port: 8001    │    │   Port: 8002    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   PostgreSQL    │
                    │   Port: 5432    │
                    └─────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         │                       │                       │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Python 智能体   │    │  Java 智能体    │    │   编排服务      │
│ (FastAPI+CrewAI)│    │(Spring AI Alibaba)│  │ (Spring Boot)   │
│   Port: 8003    │    │   Port: 8004    │    │   Port: 8005    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │      Redis      │
                    │   Port: 6379    │
                    │ (消息中间件)     │
                    └─────────────────┘
```

## 🎯 核心特性

- **🤖 多语言智能体**: 支持 Python (CrewAI) 和 Java (Spring AI Alibaba) 智能体
- **🔄 异步协作**: 通过 Redis Streams 实现智能体间的异步通信
- **⚖️ 智能编排**: 编排服务提供任务分发、负载均衡、故障恢复
- **🏗️ 整洁架构**: 采用四层架构设计，高内聚、低耦合
- **🐳 容器化部署**: Docker + Docker Compose 支持快速部署
- **📊 统一监控**: 所有服务提供标准化的健康检查接口

## 🚀 快速开始

### 环境要求

- Docker & Docker Compose
- Node.js 18+
- Rust 1.70+
- Java 17+
- Python 3.11+

### 启动开发环境

```bash
# 克隆项目
git clone <repository-url>
cd agentic_systemthinking

# 启动开发环境
make dev

# 或者使用 Docker Compose
docker-compose up -d --build
```

### 服务地址

| 服务 | 端口 | 说明 |
|------|------|------|
| **GUI应用** | 3000 | Tauri + Svelte 桌面应用 |
| **Rust后端** | 8001 | Actix-web 高性能服务 |
| **Java后端** | 8002 | Spring Boot 企业级服务 |
| **Python智能体** | 8003 | FastAPI + CrewAI 智能体 |
| **Java智能体** | 8004 | Spring AI Alibaba 智能体 |
| **编排服务** | 8005 | 智能体协调和负载均衡 |
| **PostgreSQL** | 5432 | 主数据库 |
| **Redis** | 6379 | 缓存和消息中间件 |

## 📋 可用命令

```bash
# 构建所有服务
make build

# 启动开发环境
make dev

# 停止开发环境
make dev-stop

# 重启开发环境
make dev-restart

# 查看服务日志
make logs

# 健康检查
make health-check

# 智能体状态检查
make agent-status

# Redis连接测试
make redis-test

# 查看服务状态
make status

# 清理构建文件
make clean
```

## 🔧 开发指南

### 项目结构

```
agentic_systemthinking/
├── src/                        # 源代码目录
│   ├── client/                 # 客户端应用
│   │   └── desktop/            # 桌面应用 (Tauri + Svelte)
│   ├── server/                 # 服务端应用
│   │   ├── rust/               # Rust服务 (端口 8001)
│   │   └── java/               # Java服务 (端口 8002)
│   ├── ai/                     # AI智能体
│   │   └── agents/             # 智能体系统
│   │       ├── python/         # Python智能体服务 (端口 8003)
│   │       ├── java/           # Java智能体服务 (端口 8004)
│   │       └── orchestration/  # 智能体编排服务 (端口 8005)
│   └── shared/                 # 共享代码 (预留)
├── config/                     # 配置文件
├── scripts/                    # 脚本文件
├── docker/                     # Docker相关
├── tests/                      # 测试文件
└── docs/                       # 项目文档
```

### 智能体开发

#### Python 智能体
- **框架**: FastAPI + CrewAI
- **架构**: 四层整洁架构 (Domain, Application, Infrastructure, Interfaces)
- **特性**: 异步处理、AI模型集成、任务管理

#### Java 智能体
- **框架**: Spring Boot + Spring AI Alibaba
- **架构**: 四层整洁架构 (Domain, Application, Infrastructure, Interfaces)
- **特性**: 企业级支持、类型安全、依赖注入

#### 编排服务
- **框架**: Spring Boot
- **架构**: 四层整洁架构
- **功能**: 智能体注册、任务分发、健康监控、负载均衡

### 技术栈

- **前端**: Svelte 5.0 + Tauri 2.0 + Tailwind CSS
- **后端**: Rust (Actix-web) + Java (Spring Boot)
- **AI框架**: CrewAI + Spring AI Alibaba
- **数据库**: PostgreSQL + Redis
- **部署**: Docker + Docker Compose
- **构建**: Maven + Cargo + npm

## 🔄 智能体协作流程

1. **任务提交**: 客户端向编排服务提交分析任务
2. **任务分发**: 编排服务根据智能体能力和负载情况分发任务
3. **并行处理**: Python 和 Java 智能体并行处理任务
4. **结果聚合**: 通过 Redis 收集各智能体的处理结果
5. **结果整合**: 编排服务整合结果并返回给客户端

## 📊 健康检查接口

所有后端服务都提供标准化的健康检查接口：

```bash
# 健康检查
GET /health

# 服务信息
GET /info

# 详细状态
GET /status
```

### 健康检查响应格式

```json
{
  "status": "healthy",
  "timestamp": "2024-12-17T08:00:00Z",
  "service": "service-name",
  "version": "1.0.0",
  "uptime": "2h 30m"
}
```

## 🧪 测试

```bash
# 运行所有测试
make test

# 运行特定服务测试
cd src/server/rust && cargo test
cd src/server/java && mvn test
cd src/ai/agents/python && python -m pytest tests/ -v
cd src/ai/agents/java && mvn test
cd src/ai/agents/orchestration && mvn test
```

## 🚀 部署

### 开发环境
```bash
make dev
```

### 生产环境
```bash
# 构建生产镜像
docker-compose -f docker-compose.prod.yml build

# 启动生产服务
docker-compose -f docker-compose.prod.yml up -d
```

## 📚 文档

- [项目结构说明](PROJECT_STRUCTURE.md)
- [重构状态报告](REFACTOR_STATUS.md)
- [开发指南](docs/04-implementation/development-guide.md)
- [部署指南](docs/04-implementation/deployment-guide.md)
- [架构设计](docs/02-architecture/README.md)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

### 贡献指南

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

### 开发规范

- 遵循四层整洁架构原则
- 使用统一的健康检查接口
- 保持智能体服务的独立性
- 编写完整的测试用例

## 📄 许可证

MIT License

## 📞 联系方式

- 项目主页: [GitHub Repository]
- 问题反馈: [Issues]
- 讨论交流: [Discussions]

---

**系统思维智能体项目** - 让智能体协作更简单、更高效！ 🚀
