FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY build/libs/my-app-1.0.0.jar app.jar
EXPOSE 1220
ENTRYPOINT ["java", "-jar", "app.jar"]