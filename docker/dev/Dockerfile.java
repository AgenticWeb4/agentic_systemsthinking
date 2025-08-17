# 多阶段构建 - Java后端服务
FROM maven:latest AS builder

WORKDIR /app
COPY src/server/java/pom.xml .
COPY src/server/java/src ./src

# 构建应用
RUN mvn clean package -DskipTests

# 生产阶段
FROM eclipse-temurin:17-jre

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8002
CMD ["java", "-jar", "app.jar"]
