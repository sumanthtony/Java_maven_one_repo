# Stage 1: Build the executable Spring Boot JAR
FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /app

COPY pom.xml .

COPY src ./src

RUN mvn clean package -DskipTests

# Stage 2: Run directly on Eclipse Temurin JRE

FROM eclipse-temurin:21-jre-jammy AS deployer

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]

