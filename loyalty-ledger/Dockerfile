# syntax=docker/dockerfile:1.7
FROM eclipse-temurin:21-jdk AS build
WORKDIR /src
COPY . .
RUN --mount=type=cache,target=/root/.m2 ./mvnw -B -q package -DskipTests

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /src/target/loyalty-ledger.jar app.jar
# Numeric UID so Kubernetes can validate runAsNonRoot.
USER 10001
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
