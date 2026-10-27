# syntax=docker/dockerfile:1

# ---------- Etapa 1: build ----------
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml ./
RUN mvn -B -q dependency:go-offline
COPY src ./src
# Las pruebas ya se ejecutan en el job de CI; aqui solo se empaqueta
RUN mvn -B -q package -DskipTests

# ---------- Etapa 2: runtime (imagen liviana, sin root) ----------
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Usuario sin privilegios (seguridad)
RUN addgroup -S app && adduser -S app -G app

COPY --from=build /app/target/*.jar app.jar
USER app

# Parametros de JVM pensados para contenedores (escalabilidad / memoria)
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75 -XX:+UseContainerSupport"

EXPOSE 8080

HEALTHCHECK --interval=15s --timeout=3s --start-period=40s --retries=5 \
  CMD wget -q -O /dev/null http://localhost:8080/v3/api-docs || exit 1

ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar app.jar"]
