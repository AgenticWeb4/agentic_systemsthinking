FROM openjdk:17-jdk-slim

WORKDIR /app

# 安装 Maven
RUN apt-get update && apt-get install -y \
    maven \
    && rm -rf /var/lib/apt/lists/*

# 复制 pom.xml
COPY pom.xml .

# 下载依赖
RUN mvn dependency:go-offline -B

# 复制源代码
COPY src ./src

# 编译应用
RUN mvn clean package -DskipTests

# 暴露端口
EXPOSE 8004

# 启动命令
CMD ["java", "-jar", "target/systemthinking-agents-1.0.0.jar"]
