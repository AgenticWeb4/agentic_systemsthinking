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
│   │   └── python/             # Python服务
│   ├── ai/                     # AI智能体
│   │   └── agents/             # 智能体系统
│   └── shared/                 # 共享代码
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
  - 使用CrewAI框架
  - 集成LangChain
  - 支持多种AI模型

#### shared/ - 共享代码
- **types/**: 类型定义
  - 跨服务的数据类型
  - API接口定义
  - 数据库模型

- **utils/**: 工具函数
  - 通用工具函数
  - 辅助方法
  - 验证函数

- **constants/**: 常量定义
  - 系统常量
  - 配置常量
  - 枚举值

### config/ - 配置文件

#### env/ - 环境配置
- 开发环境配置
- 测试环境配置
- 生产环境配置

#### docker/ - Docker配置
- 开发环境Dockerfile
- 测试环境配置
- 生产环境配置

#### nginx/ - Nginx配置
- 反向代理配置
- 负载均衡配置
- SSL证书配置

#### database/ - 数据库配置
- 数据库初始化脚本
- 迁移脚本
- 种子数据

### scripts/ - 脚本文件

#### dev/ - 开发脚本
- 开发环境启动
- 服务测试
- 环境切换

#### deploy/ - 部署脚本
- 生产环境部署
- 服务更新
- 回滚脚本

#### tools/ - 工具脚本
- 配置验证
- 代码检查
- 性能测试

### docker/ - Docker相关

#### dev/ - 开发环境
- 开发环境Dockerfile
- 开发环境配置
- 本地开发支持

#### test/ - 测试环境
- 测试环境配置
- 自动化测试
- 集成测试

#### prod/ - 生产环境
- 生产环境配置
- 性能优化
- 安全配置

## 🔄 迁移说明

### 从旧结构迁移
- `apps/gui/` → `src/client/desktop/`
- `apps/backend-rust/` → `src/server/rust/`
- `apps/backend-java/` → `src/server/java/`
- `apps/agent-system/` → `src/ai/agents/`
- `configs/` → `config/`
- `infrastructure/` → `docker/`
- `tools/` → `scripts/tools/`

### 路径更新
- Docker Compose文件已更新
- Makefile已更新
- 启动脚本已更新
- 配置文件路径已更新

## 📝 使用建议

1. **开发新功能时**：在对应的`src/`子目录下创建
2. **添加新服务时**：在`src/server/`下创建新目录
3. **添加新客户端时**：在`src/client/`下创建新目录
4. **添加新AI功能时**：在`src/ai/`下创建新目录
5. **配置文件**：统一放在`config/`目录下
6. **脚本文件**：按功能分类放在`scripts/`目录下

## 🚀 快速开始

```bash
# 查看项目结构
tree -L 3 -I 'node_modules|target|__pycache__|*.pyc'

# 启动开发环境
make dev

# 查看服务状态
make status

# 查看日志
make logs
```
