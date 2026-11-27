# Stage 1: Build the .war file
FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

# Stage 2: Run on plain Eclipse Temurin JRE using Jetty Runner
FROM eclipse-temurin:21-jre-jammy AS deployer

WORKDIR /app

# Download lightweight Jetty Runner (compatible with Jakarta EE / Tomcat 10+ WARs)
ADD https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-runner/11.0.24/jetty-runner-11.0.24.jar jetty-runner.jar

# Copy your compiled WAR file
COPY --from=build /app/target/*.war app.war

EXPOSE 8080
CMD ["java", "-jar", "jetty-runner.jar", "--port", "8080", "app.war"]
