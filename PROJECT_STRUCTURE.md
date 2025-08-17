# 项目目录结构说明

## 📁 目录结构概览

```
agentic_systemthinking/
├── src/                        # 源代码目录
│   ├── client/                 # 客户端应用
│   │   ├── desktop/            # 桌面应用 (Tauri + Svelte)
│   │   └── web/                # Web应用 (预留)
│   ├── server/                 # 服务端应用
│   │   ├── rust/               # Rust服务
│   │   ├── java/               # Java服务
│   │   └── python/             # Python服务 (预留)
│   ├── ai/                     # AI智能体
│   │   └── agents/             # 智能体系统
│   │       ├── python/         # Python智能体服务
│   │       ├── java/           # Java智能体服务
│   │       └── orchestration/  # 智能体编排服务
│   └── shared/                 # 共享代码 (预留)
│       ├── types/              # 类型定义
│       ├── utils/              # 工具函数
│       └── constants/          # 常量定义
├── config/                     # 配置文件
│   ├── env/                    # 环境配置
│   ├── docker/                 # Docker配置
│   ├── nginx/                  # Nginx配置
│   └── database/               # 数据库配置
├── scripts/                    # 脚本文件
│   ├── dev/                    # 开发脚本
│   ├── deploy/                 # 部署脚本
│   └── tools/                  # 工具脚本
├── docs/                       # 项目文档
├── tests/                      # 测试文件
├── docker/                     # Docker相关
│   ├── dev/                    # 开发环境
│   ├── test/                   # 测试环境
│   └── prod/                   # 生产环境
├── .github/                     # GitHub配置
├── .vscode/                     # VS Code配置
├── .gitignore                   # Git忽略文件
├── docker-compose.yml           # Docker编排
├── Makefile                     # 构建脚本
├── README.md                    # 项目说明
└── CHANGELOG.md                 # 变更日志
```

## 🎯 设计原则

### 1. 命名一致性
- 使用简洁、清晰的英文命名
- 避免缩写和特殊字符
- 保持目录层级的一致性

### 2. 功能分组
- `src/`: 所有源代码
- `config/`: 所有配置文件
- `scripts/`: 所有脚本文件
- `docker/`: 所有Docker相关

### 3. 扩展性
- 支持添加新的客户端类型
- 支持添加新的服务端技术栈
- 支持添加新的AI模型

### 4. 开发友好
- 符合主流开发习惯
- 便于IDE识别和导航
- 支持多语言开发

## 📂 详细说明

### src/ - 源代码目录

#### client/ - 客户端应用
- **desktop/**: Tauri桌面应用
  - 使用Svelte 5.0 + Tauri 2.0
  - 支持跨平台桌面应用
  - 集成Tailwind CSS

- **web/**: Web应用（预留）
  - 为未来Web版本预留
  - 可共享desktop的组件

#### server/ - 服务端应用
- **rust/**: Rust后端服务
  - 使用Actix-web框架
  - 高性能并发处理
  - PostgreSQL数据库连接

- **java/**: Java后端服务
  - 使用Spring Boot框架
  - 企业级应用支持
  - JPA数据访问

- **python/**: Python后端服务（预留）
  - 为未来Python服务预留
  - 可集成FastAPI等框架

#### ai/ - AI智能体
- **agents/**: 智能体系统
  - **python/**: Python智能体服务
    - 使用FastAPI框架
    - 集成CrewAI智能体框架
    - 支持异步处理
    - 端口: 8003
  
  - **java/**: Java智能体服务
    - 使用Spring Boot框架
    - 集成Spring AI Alibaba
    - 企业级智能体支持
    - 端口: 8004
  
  - **orchestration/**: 智能体编排服务
    - 使用Spring Boot框架
    - 四层整洁架构设计
    - 智能体协调和负载均衡
    - 端口: 8005

### 智能体协作架构
- **Redis作为消息中间件**: 智能体间通过Redis Streams进行异步通信
- **编排服务作为协调中心**: 负责任务分发、状态监控、负载均衡
- **统一健康检查接口**: 所有后端服务提供`/health`端点
- **服务发现**: 通过编排服务进行智能体注册和发现

### 服务端口分配
- **GUI应用**: 3000
- **Rust后端**: 8001
- **Java后端**: 8002
- **Python智能体**: 8003
- **Java智能体**: 8004
- **编排服务**: 8005
- **PostgreSQL**: 5432
- **Redis**: 6379
