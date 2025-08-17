# Agentic System - 脚本使用说明

## 📋 概述

本目录包含了Agentic System项目的所有管理脚本，经过重构后采用了模块化设计，提高了可维护性和可靠性。

## 🏗️ 架构设计

### 目录结构
```
scripts/
├── lib/                    # 通用函数库
│   └── common.sh          # 核心函数库
├── config/                 # 配置文件
│   ├── services.conf      # 服务配置
│   └── ports.conf         # 端口配置
├── dev/                    # 开发环境脚本
│   ├── start-complete.sh  # 完整启动脚本
│   ├── stop-complete.sh   # 完整停止脚本
│   ├── restart.sh         # 重启服务脚本
│   ├── status.sh          # 状态查看脚本
│   ├── cleanup.sh         # 清理资源脚本
│   ├── check-docker.sh    # Docker检查脚本
│   ├── test-services.sh   # 服务测试脚本
│   └── test-endpoints.sh  # 端点测试脚本
├── tools/                  # 工具脚本
│   └── validate-config.sh # 配置验证脚本
└── deploy/                 # 部署脚本（待开发）
```

### 设计原则
- **模块化**: 通用功能提取到函数库
- **配置驱动**: 硬编码信息提取到配置文件
- **错误处理**: 统一的错误处理和用户反馈
- **路径管理**: 使用绝对路径，避免相对路径问题
- **向后兼容**: 保持现有脚本的调用方式

## 🚀 快速开始

### 1. 启动完整环境
```bash
./scripts/dev/start-complete.sh
```
这将启动所有Docker服务和前端应用。

### 2. 查看服务状态
```bash
./scripts/dev/status.sh
```
查看所有服务的运行状态和健康状态。

### 3. 停止所有服务
```bash
./scripts/dev/stop-complete.sh
```
停止所有Docker服务和GUI应用。

## 📚 脚本详细说明

### 核心脚本

#### `start-complete.sh` - 完整启动脚本
- **功能**: 启动所有核心服务和GUI应用
- **特点**: 自动检查环境、创建目录、管理进程
- **输出**: 彩色日志、状态反馈、使用说明

#### `stop-complete.sh` - 完整停止脚本
- **功能**: 停止所有服务和清理资源
- **特点**: 安全停止前端进程、清理PID文件
- **输出**: 操作确认、状态反馈

#### `restart.sh` - 重启脚本
- **功能**: 重启所有服务
- **特点**: 先停止再启动，确保干净重启
- **输出**: 重启进度、状态确认

#### `status.sh` - 状态查看脚本
- **功能**: 查看所有服务的详细状态
- **特点**: 系统信息、Docker状态、端口占用、健康检查
- **输出**: 结构化状态报告

### 管理脚本

#### `cleanup.sh` - 清理脚本
- **功能**: 清理所有项目资源
- **特点**: 交互式确认、全面清理、安全提示
- **清理内容**: Docker资源、日志文件、构建产物、依赖

#### `check-docker.sh` - Docker检查脚本
- **功能**: 检查Docker环境和端口占用
- **特点**: 环境验证、端口冲突检测
- **输出**: 检查结果、问题诊断

### 测试脚本

#### `test-services.sh` - 服务测试脚本
- **功能**: 测试所有服务的健康状态
- **特点**: 配置驱动、自动测试、结果汇总
- **测试内容**: 健康检查、数据库连接、服务可用性

#### `test-endpoints.sh` - 端点测试脚本
- **功能**: 测试各个服务的API端点
- **特点**: 端点验证、响应检查、格式美化
- **测试内容**: 健康端点、数据库端点、GUI访问

## ⚙️ 配置说明

### `services.conf` - 服务配置
```bash
# 服务端口配置
declare -A SERVICE_PORTS=(
    ["gui"]="3000"
    ["rust-backend"]="8001"
    ["java-backend"]="8002"
    # ... 更多服务
)

# 健康检查端点
declare -A HEALTH_ENDPOINTS=(
    ["rust-backend"]="/health"
    ["java-backend"]="/health"
    # ... 更多端点
)
```

### `ports.conf` - 端口配置
```bash
# 端口分配说明
FRONTEND_PORTS=(["gui"]="3000")
BACKEND_PORTS=(["rust-backend"]="8001")
STORAGE_PORTS=(["postgres"]="5432")
```

## 🔧 通用函数库

### `common.sh` - 核心函数库
提供了以下功能：
- **日志函数**: `log_info`, `log_success`, `log_warning`, `log_error`
- **检查函数**: `check_docker`, `check_port`, `check_all_ports`
- **工具函数**: `wait_for_service`, `show_service_status`
- **错误处理**: 统一的错误处理和退出机制

## 📖 使用示例

### 开发工作流
```bash
# 1. 启动开发环境
./scripts/dev/start-complete.sh

# 2. 开发过程中查看状态
./scripts/dev/status.sh

# 3. 测试服务
./scripts/dev/test-services.sh

# 4. 重启服务（如果需要）
./scripts/dev/restart.sh

# 5. 停止开发环境
./scripts/dev/stop-complete.sh
```

### 问题排查
```bash
# 1. 检查Docker状态
./scripts/dev/check-docker.sh

# 2. 查看详细状态
./scripts/dev/status.sh

# 3. 测试端点
./scripts/dev/test-endpoints.sh

# 4. 清理资源（如果需要）
./scripts/dev/cleanup.sh
```

## 🚨 注意事项

1. **权限要求**: 确保脚本有执行权限
2. **依赖检查**: 脚本会自动检查必要的工具（Docker、curl等）
3. **路径管理**: 脚本使用绝对路径，可以在任何目录下运行
4. **错误处理**: 遇到错误时会显示详细的错误信息和解决建议
5. **资源清理**: `cleanup.sh` 会清理所有资源，请谨慎使用

## 🔄 版本历史

- **v2.0.0**: 重构版本，采用模块化架构
- **v1.x.x**: 原始版本（已废弃）

## 📞 支持

如果遇到问题，请：
1. 查看脚本的错误输出
2. 运行 `./scripts/dev/status.sh` 查看状态
3. 检查日志文件
4. 参考本文档的使用说明
