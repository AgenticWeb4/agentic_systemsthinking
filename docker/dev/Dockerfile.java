# 多阶段构建 - Java后端服务 (优化版)
FROM maven:latest AS deps

WORKDIR /app

# 复制pom.xml文件
COPY src/server/java/pom.xml .

# 预下载所有依赖到本地仓库 (只下载，不编译)
RUN mvn dependency:go-offline -B \
    && mvn dependency:resolve -B \
    && mvn dependency:resolve-plugins -B

# 构建阶段
FROM maven:latest AS builder

WORKDIR /app

# 复制pom.xml
COPY src/server/java/pom.xml .

# 复制预下载的依赖
COPY --from=deps /root/.m2 /root/.m2

# 复制源代码
COPY src/server/java/src ./src

# 使用offline模式构建 (跳过依赖下载)
RUN mvn clean package -DskipTests -o

# 生产阶段
FROM eclipse-temurin:17-jre

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

# 设置JVM优化参数
ENV JAVA_OPTS="-Xms512m -Xmx1024m -XX:+UseG1GC -XX:+UseContainerSupport"

EXPOSE 8002

# 使用环境变量配置JVM参数
CMD java $JAVA_OPTS -jar app.jar
