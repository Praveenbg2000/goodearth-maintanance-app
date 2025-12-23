# ===========================
# 1️⃣ Build stage
# ===========================
FROM maven:3.9.9-eclipse-temurin-17 AS build

# Set working directory inside container
WORKDIR /app

# Copy pom.xml and wrapper files first (for caching)
COPY pom.xml mvnw* ./
COPY .mvn/ .mvn/

# ✅ Fix: Add execute permission for mvnw
RUN chmod +x mvnw

# Download dependencies
RUN ./mvnw dependency:go-offline -B

# Copy source code
COPY src ./src

# Package the app (skip tests to save time)
RUN ./mvnw clean package -DskipTests

# ===========================
# 2️⃣ Runtime stage
# ===========================
FROM eclipse-temurin:17-jdk

# Set working directory for runtime container
WORKDIR /app

# Copy built JAR from previous stage
COPY --from=build /app/target/*.jar app.jar

# Expose Spring Boot default port
EXPOSE 8080

# Run the JAR
ENTRYPOINT ["java", "-jar", "app.jar"]
