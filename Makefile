# 系统思维智能体项目 Makefile

.PHONY: help build clean dev test deploy logs

# 默认目标
help:
	@echo "系统思维智能体项目 - 可用命令:"
	@echo "  build     - 构建所有服务"
	@echo "  dev       - 启动开发环境"
	@echo "  test      - 运行测试"
	@echo "  clean     - 清理构建文件"
	@echo "  logs      - 查看服务日志"
	@echo "  deploy    - 部署到生产环境"
	@echo "  validate-config - 验证配置完整性"

# 构建所有服务
build:
	@echo "构建所有服务..."
	@cd src/client/desktop && npm install
	@cd src/server/rust && cargo build --release
	@cd src/server/java && mvn clean package -DskipTests
	@cd src/ai/agents && pip install -r requirements.txt
	@echo "构建完成!"

# 启动开发环境
dev:
	@echo "启动开发环境..."
	@./scripts/dev/check-docker.sh
	@docker-compose up -d --build
	@echo "开发环境启动完成!"
	@echo "服务地址:"
	@echo "  GUI应用: http://localhost:3000"
	@echo "  Rust后端: http://localhost:8001"
	@echo "  Java后端: http://localhost:8002"
	@echo "  智能体系统: http://localhost:8003"
	@echo "  PostgreSQL: localhost:5432"
	@echo "  Redis: localhost:6379"

# 停止开发环境
dev-stop:
	@echo "停止开发环境..."
	docker-compose down
	@echo "开发环境已停止!"

# 重启开发环境
dev-restart:
	@echo "重启开发环境..."
	docker-compose restart
	@echo "开发环境重启完成!"

# 查看服务日志
logs:
	@echo "查看服务日志..."
	docker-compose logs -f

# 查看特定服务日志
logs-service:
	@echo "查看服务日志 (请指定服务名: make logs-service SERVICE=rust-backend)"
	@docker-compose logs -f $(SERVICE)

# 运行测试
test:
	@echo "运行测试..."
	@cd apps/backend-rust && cargo test
	@cd apps/backend-java && mvn test
	@cd apps/agent-system && python -m pytest tests/ -v

# 清理构建文件
clean:
	@echo "清理构建文件..."
	@cd src/client/desktop && rm -rf node_modules dist
	@cd src/server/rust && cargo clean
	@cd src/server/java && mvn clean
	@cd src/ai/agents && find . -type d -name __pycache__ -delete
	@docker-compose down -v
	@docker system prune -f
	@echo "清理完成!"

# 部署到生产环境
deploy:
	@echo "部署到生产环境..."
	@echo "请配置生产环境参数后执行部署"

# 健康检查
health-check:
	@echo "检查服务健康状态..."
	@curl -s http://localhost:8001/health | jq .
	@curl -s http://localhost:8002/health | jq .
	@curl -s http://localhost:8003/health | jq .

# 数据库连接测试
db-test:
	@echo "测试数据库连接..."
	@docker exec agentic_postgres psql -U postgres -d agentic_systemthinking -c "SELECT version();"

# 服务状态
status:
	@echo "查看服务状态..."
	@docker-compose ps

# 配置验证
validate-config:
	@echo "验证配置完整性..."
	@./tools/scripts/validate-config.sh
