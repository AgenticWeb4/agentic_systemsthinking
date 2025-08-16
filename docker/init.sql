-- 数据库初始化脚本
-- 系统思维智能体项目

-- 创建扩展
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 创建服务状态表
CREATE TABLE IF NOT EXISTS service_status (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    service_name VARCHAR(100) NOT NULL,
    status VARCHAR(50) NOT NULL,
    health_check_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    details JSONB
);

-- 创建智能体表
CREATE TABLE IF NOT EXISTS agents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(200) NOT NULL,
    agent_type VARCHAR(100) NOT NULL,
    capabilities JSONB,
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建任务表
CREATE TABLE IF NOT EXISTS tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(500) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'pending',
    priority INTEGER DEFAULT 1,
    assigned_agent_id UUID REFERENCES agents(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建团队表
CREATE TABLE IF NOT EXISTS teams (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(200) NOT NULL,
    description TEXT,
    collaboration_mode VARCHAR(100),
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建团队成员关系表
CREATE TABLE IF NOT EXISTS team_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    team_id UUID REFERENCES teams(id),
    agent_id UUID REFERENCES agents(id),
    role VARCHAR(100),
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(team_id, agent_id)
);

-- 插入初始数据
INSERT INTO service_status (service_name, status, details) VALUES
('rust-backend', 'healthy', '{"version": "1.0.0", "port": 8001, "database": "mydb"}'),
('java-backend', 'healthy', '{"version": "1.0.0", "port": 8002, "database": "mydb"}'),
('agent-system', 'healthy', '{"version": "1.0.0", "port": 8003, "database": "mydb"}'),
('gui', 'healthy', '{"version": "1.0.0", "port": 3000}');

INSERT INTO agents (name, agent_type, capabilities) VALUES
('TaskExecutor', 'executor', '{"task_types": ["analysis", "execution", "monitoring"]}'),
('DecisionMaker', 'decision', '{"decision_methods": ["rule_based", "ml_based", "hybrid"]}'),
('MemoryManager', 'memory', '{"memory_types": ["short_term", "long_term", "episodic"]}'),
('Coordinator', 'coordination', '{"coordination_modes": ["sequential", "parallel", "hierarchical"]}');

INSERT INTO teams (name, description, collaboration_mode) VALUES
('Core Team', '核心智能体团队', 'hierarchical'),
('Analysis Team', '分析智能体团队', 'parallel'),
('Execution Team', '执行智能体团队', 'sequential');

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_service_status_service_name ON service_status(service_name);
CREATE INDEX IF NOT EXISTS idx_agents_agent_type ON agents(agent_type);
CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);
CREATE INDEX IF NOT EXISTS idx_tasks_assigned_agent ON tasks(assigned_agent_id);

-- 创建更新时间触发器函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 创建触发器
CREATE TRIGGER update_agents_updated_at BEFORE UPDATE ON agents
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON tasks
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
