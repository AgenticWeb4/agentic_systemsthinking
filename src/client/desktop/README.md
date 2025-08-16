# GUI应用

系统思维智能体项目的桌面GUI应用，基于Tauri + Svelte构建。

## 技术栈

- **前端框架**: Svelte 5.0.0 + SvelteKit 2.0.0
- **跨平台**: Tauri 2.0.0
- **样式**: Tailwind CSS + Skeleton UI
- **构建工具**: Vite 5.0.0

## 功能特性

- 服务健康状态监控
- 实时状态更新
- 响应式设计
- 跨平台支持

## 开发环境

### 环境要求
- Node.js 18+
- Rust 1.70+
- Tauri CLI

### 安装依赖
```bash
npm install
```

### 开发模式
```bash
npm run dev
```

### Tauri开发模式
```bash
npm run tauri:dev
```

### 构建应用
```bash
npm run tauri:build
```

## 项目结构

```
gui/
├── src/                    # 源代码
│   ├── lib/               # 组件库
│   ├── routes/            # 页面路由
│   ├── stores/            # 状态管理
│   ├── app.html           # 主页面
│   └── app.css            # 全局样式
├── src-tauri/             # Tauri后端
│   ├── src/               # Rust源码
│   ├── Cargo.toml         # Rust配置
│   └── tauri.conf.json    # Tauri配置
├── public/                 # 静态资源
├── package.json            # Node.js配置
├── vite.config.js          # Vite配置
├── svelte.config.js        # Svelte配置
└── tailwind.config.js      # Tailwind配置
```

## API端点

- `GET /health` - 服务健康检查
- `GET /db-health` - 数据库健康检查

## 部署

支持Docker容器化部署，详见Docker配置文件。

---

**维护团队**: 系统工程开发团队  
**最后更新**: 2024年12月
