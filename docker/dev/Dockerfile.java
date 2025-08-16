# 多阶段构建 - Java后端服务
FROM maven:3.9.5-openjdk-17 AS builder

WORKDIR /app
COPY pom.xml .
COPY src ./src

# 构建应用
RUN mvn clean package -DskipTests

# 生产阶段
FROM openjdk:17-jre-alpine

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8002
CMD ["java", "-jar", "app.jar"]
