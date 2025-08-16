# 系统思维智能体项目

一个基于多技术栈的智能体系统项目，采用Monorepo架构，支持前端、后端和AI智能体的协同开发。

## 🏗️ 项目架构

```
agentic_systemthinking/
├── src/                        # 源代码目录
│   ├── client/                 # 客户端应用
│   │   └── desktop/            # 桌面应用 (Tauri + Svelte)
│   ├── server/                 # 服务端应用
│   │   ├── rust/               # Rust服务
│   │   ├── java/               # Java服务
│   │   └── python/             # Python服务
│   ├── ai/                     # AI智能体
│   │   └── agents/             # 智能体系统
│   └── shared/                 # 共享代码
├── config/                     # 配置文件
├── scripts/                    # 脚本文件
├── docs/                       # 项目文档
├── tests/                      # 测试文件
├── docker/                     # Docker相关
└── docker-compose.yml          # Docker编排
```

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
./scripts/dev/start-dev.sh

# 或者使用Makefile
make dev
```

### 服务地址

- **GUI应用**: http://localhost:3000
- **Rust后端**: http://localhost:8001
- **Java后端**: http://localhost:8002
- **智能体系统**: http://localhost:8003
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379

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

# 查看服务状态
make status

# 清理构建文件
make clean
```

## 🔧 开发指南

### 项目结构说明

- **src/client/desktop/**: Tauri + Svelte桌面应用
- **src/server/rust/**: Rust后端服务 (Actix-web)
- **src/server/java/**: Java后端服务 (Spring Boot)
- **src/ai/agents/**: Python智能体系统 (FastAPI + CrewAI)

### 技术栈

- **前端**: Svelte 5.0 + Tauri 2.0 + Tailwind CSS
- **后端**: Rust (Actix-web) + Java (Spring Boot) + Python (FastAPI)
- **AI**: CrewAI + LangChain + DeepSeek
- **数据库**: PostgreSQL + Redis
- **部署**: Docker + Docker Compose

## 📚 文档

- [系统架构文档](architecture/system-overview.md)
- [领域驱动设计](architecture/domain-driven-design.md)
- [用户故事映射](requirements/user-story-mapping.md)
- [开发指南](implementation/development-guide.md)
- [部署指南](implementation/deployment-guide.md)

## 🤝 贡献

欢迎提交Issue和Pull Request！

## �� 许可证

MIT License
