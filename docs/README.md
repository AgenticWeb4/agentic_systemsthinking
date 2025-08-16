# 系统工程架构文档

本目录包含了系统思维项目的各个技术栈的工程架构文档。

## 文档结构

```
docs/
├── README.md                           # 本文档
├── 01-requirements/                    # 需求文档
│   ├── README.md                       # 需求文档说明
│   └── user-story-mapping.md          # 用户故事地图
├── 02-architecture/                    # 架构文档
│   ├── README.md                       # 架构文档说明
│   ├── system-overview.md              # 系统架构概览
│   └── domain-driven-design.md         # DDD架构设计
├── 03-technology/                      # 技术架构文档
│   ├── README.md                       # 技术架构说明
│   ├── agent-architecture.md           # 智能体架构
│   ├── backend-architecture.md         # 后端架构
│   └── frontend-architecture.md        # 前端架构
└── 04-implementation/                  # 实现文档
    ├── README.md                       # 实现文档说明
    ├── development-guide.md             # 开发指南
    └── deployment-guide.md              # 部署指南
```

## 文档说明

### 智能体工程架构文档
- **技术栈**: CrewAI + LangChain + Python + DeepSeek
- **特点**: 多层智能体架构、协作机制、记忆系统
- **适用场景**: 复杂多智能体协作系统开发

### Rust服务开发工程架构文档
- **技术栈**: Rust + Actix-web + Tokio
- **特点**: 高性能、内存安全、并发处理
- **适用场景**: 高性能后端服务开发

### Java服务开发工程架构文档
- **技术栈**: Spring Boot + Spring Cloud
- **特点**: 企业级、生态丰富、成熟稳定
- **适用场景**: 企业级应用开发

### 前端工程架构文档
- **技术栈**: Svelte + Tauri + SvelteKit
- **特点**: 轻量级、跨平台、现代开发体验
- **适用场景**: 桌面应用和Web应用开发

## 使用建议

1. 根据项目需求选择相应的技术栈架构文档
2. 参考文档中的最佳实践和设计原则
3. 严格按照限定的技术栈版本进行开发
4. 遵循文档中的开发规范和代码标准

## 维护说明

- 文档版本: 1.0.0
- 最后更新: 2024年12月
- 维护团队: 系统工程开发团队
