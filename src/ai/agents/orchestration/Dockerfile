# 使用 OpenJDK 17 作为基础镜像
FROM openjdk:17-jdk-slim

# 设置工作目录
WORKDIR /app

# 复制 Maven 配置文件
COPY pom.xml .

# 复制源代码
COPY src ./src

# 安装 Maven
RUN apt-get update && apt-get install -y maven

# 构建应用
RUN mvn clean package -DskipTests

# 暴露端口
EXPOSE 8005

# 启动应用
CMD ["java", "-jar", "target/agent-orchestration-1.0.0.jar"]
