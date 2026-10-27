# Postulaciones — Despliegue y operación

## Requisitos

- Java 21, Maven 3.9 (build local)
- Docker + Docker Compose (despliegue)

## Ejecución local

```bash
mvn spring-boot:run
```

URLs en `http://localhost:8080`:

| Recurso | URL |
|---------|-----|
| Página de presentación | `/` |
| Swagger UI | `/swagger-ui/index.html` |
| OpenAPI yaml | `/v3/api-docs.yaml` |
| ReDoc | `/redoc.html` |
| H2 Console | `/h2-console` |
| API base | `/api/postulaciones` |

## Docker

```bash
docker build -t duoc/jv0101-caso02-postulaciones:1.0.0 .
docker run -p 8080:8080 duoc/jv0101-caso02-postulaciones:1.0.0
```

## Docker Compose

```bash
docker compose up --build
PORT=9090 docker compose up --build   # cambiar puerto host
```

## Base de datos

H2 en memoria (se pierde al detener el contenedor), configurable en `src/main/resources/application.yml`. Consola web en `/h2-console` (JDBC URL, usuario `sa`, sin clave).

## Variables de entorno

| Variable | Defecto | Descripción |
|----------|---------|-------------|
| `PORT` | `8080` | Puerto del servidor y mapeo del contenedor |

## Pipeline CI/CD y despliegue automático

El despliegue lo ejecuta el workflow `.github/workflows/ci-cd.yml` (ver sección *Pipeline CI/CD* del README):

1. `test-and-analyze`: pruebas, JaCoCo y SonarCloud (con Quality Gate bloqueante).
2. `build-image`: construye y publica `ghcr.io/<owner>/postulaciones-svc:<SHA>`.
3. `deploy`: levanta esa imagen con Docker Compose en el entorno simulado (`staging` para `develop`, `production` para `main`) y hace un smoke test.

Despliegue manual de una versión concreta:

```bash
IMAGE=ghcr.io/<owner>/postulaciones-svc:<sha> docker compose up -d --no-build --wait
```

## Orquestación con Kubernetes

Los manifiestos están en `k8s/` (`deployment.yaml`, `service.yaml`, `hpa.yaml`): 2 réplicas, rolling update, probes, límites de recursos y autoscaling por CPU.

## Variables de entorno adicionales

| Variable | Defecto | Descripción |
|----------|---------|-------------|
| `IMAGE` | `duoc/dy0101-postulaciones-svc:local` | Imagen a desplegar con Compose |
| `H2_CONSOLE_ENABLED` | `true` local / `false` en Compose | Habilita la consola H2 |
| `SHOW_SQL` | `false` | Muestra el SQL de Hibernate en logs |
| `JAVA_OPTS` | `-XX:MaxRAMPercentage=75` | Parámetros de la JVM |
