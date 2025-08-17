# 系统思维智能体项目 - 桌面端应用

## 项目概述

这是一个基于 Tauri 2.0 + Svelte 5.0 + SvelteKit 2.0 的现代化桌面应用，用于监控和管理系统思维智能体项目的各个服务组件。

## 技术栈

- **前端框架**: Svelte 5.0 + SvelteKit 2.0
- **桌面框架**: Tauri 2.0
- **样式框架**: Tailwind CSS 3.4
- **构建工具**: Vite 5.0
- **开发语言**: TypeScript

## 项目结构

```
src/
├── lib/
│   ├── components/          # 可复用组件
│   │   ├── StatusCard.svelte    # 服务状态卡片组件
│   │   ├── ThemeToggle.svelte   # 主题切换按钮
│   │   ├── LoadingSpinner.svelte # 加载动画组件
│   │   └── RefreshButton.svelte # 刷新按钮组件
│   ├── stores/              # 状态管理
│   │   └── theme.ts         # 主题状态存储
│   ├── types/               # 类型定义
│   │   └── service.ts       # 服务相关类型
│   └── utils/               # 工具函数
│       └── healthCheck.ts   # 服务健康检查
├── routes/                  # 页面路由
│   └── +page.svelte        # 主页面
└── app.html                 # HTML模板
```

## 主要功能

### 🎨 现代化UI设计
- **响应式设计**: 支持移动端、平板、桌面端
- **明暗主题**: 支持亮色和暗色主题切换
- **Material Design**: 遵循Material Design 3.0设计原则
- **微交互动画**: 平滑的过渡动画和悬停效果

### 🔍 服务监控
- **实时状态**: 监控所有后端服务的健康状态
- **数据库状态**: 检查各服务的数据库连接状态
- **自动刷新**: 每30秒自动检查服务状态
- **手动刷新**: 支持手动刷新状态

### 🚀 技术特性
- **组件化架构**: 高度模块化的组件设计
- **类型安全**: 完整的TypeScript类型支持
- **状态管理**: 使用Svelte stores进行状态管理
- **性能优化**: 支持服务端渲染(SSR)和静态生成

## 开发指南

### 环境要求
- Node.js 18+
- npm 或 yarn

### 安装依赖
```bash
npm install
```

### 开发模式
```bash
npm run dev
```

### 构建生产版本
```bash
npm run build
```

### Tauri开发
```bash
npm run tauri:dev
```

### Tauri构建
```bash
npm run tauri:build
```

## 组件说明

### StatusCard 组件
显示单个服务的状态信息，包括服务状态和数据库状态。

**属性:**
- `title`: 服务名称
- `status`: 服务状态 (Healthy/Unhealthy/Checking...)
- `dbStatus`: 数据库状态
- `loading`: 是否正在加载
- `theme`: 当前主题 (light/dark)

### ThemeToggle 组件
固定在右上角的主题切换按钮，支持明暗主题切换。

### LoadingSpinner 组件
现代化的加载动画，支持不同尺寸和主题。

**属性:**
- `size`: 尺寸 (sm/md/lg)
- `theme`: 当前主题

### RefreshButton 组件
刷新按钮，支持加载状态显示。

**属性:**
- `loading`: 是否正在刷新

## 主题系统

应用支持明暗主题切换，主题设置会保存在localStorage中。

### 亮色主题
- 背景: 浅灰色
- 卡片: 白色
- 文字: 深灰色
- 主色调: 蓝色

### 暗色主题
- 背景: 深灰色
- 卡片: 深色
- 文字: 白色
- 主色调: 蓝色

## 响应式设计

- **移动端**: 单列布局，优化触摸体验
- **平板**: 双列布局
- **桌面端**: 三列布局，充分利用屏幕空间

## 性能优化

- **懒加载**: 组件按需加载
- **缓存**: 主题设置本地缓存
- **并行请求**: 服务健康检查并行执行
- **防抖**: 避免频繁的状态更新

## 浏览器兼容性

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## 贡献指南

1. Fork 项目
2. 创建功能分支
3. 提交更改
4. 推送到分支
5. 创建 Pull Request

## 许可证

MIT License
