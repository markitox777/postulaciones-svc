# Documentación DevOps — Postulaciones SVC

## 1. Objetivo

El objetivo de la configuración DevOps es automatizar la compilación, las pruebas, el análisis de calidad y la comprobación del despliegue del microservicio Postulaciones.

Para esto se utilizan GitHub Actions, Maven, SonarCloud, Docker, Docker Compose y Dependabot.

## 2. Integración continua (CI)

El proyecto utiliza GitHub Actions para ejecutar automáticamente el pipeline cuando se realizan cambios en las ramas `main` y `develop`, y cuando se crean o actualizan Pull Requests dirigidos a `main`.

El workflow se encuentra en:

`.github/workflows/hola-mundo.yml`

Las principales etapas son:

1. Descargar el código del repositorio.
2. Configurar Java 21 y Maven.
3. Comprobar que el secreto `SONAR_TOKEN` esté disponible.
4. Ejecutar las pruebas y la verificación del proyecto mediante `mvn clean verify`.
5. Analizar el código con SonarCloud.
6. Validar la configuración de Docker Compose.
7. Construir e iniciar temporalmente la aplicación en Docker.
8. Comprobar que Swagger responda correctamente.
9. Detener los contenedores utilizados durante la ejecución.

Las etapas de Docker se ejecutan en eventos `push` cuando las etapas anteriores terminan correctamente. En los Pull Requests se ejecutan las pruebas y el análisis, pero no el despliegue temporal.

## 3. Pruebas y calidad del código

Maven se utiliza para compilar el proyecto y ejecutar las pruebas automatizadas.

Comandos principales:

- `mvn test`: ejecuta las pruebas configuradas.
- `mvn verify`: ejecuta la verificación del proyecto y las comprobaciones de cobertura configuradas con JaCoCo.

JaCoCo está configurado con un mínimo de cobertura de líneas del 100 %. Si la cobertura no cumple el umbral configurado, la verificación puede fallar.

SonarCloud realiza el análisis de calidad del código. Los resultados deben revisarse en el proyecto correspondiente de SonarCloud.

## 4. Seguridad y gestión de dependencias

### SonarCloud

El análisis se ejecuta desde el pipeline de GitHub Actions.

El token de autenticación se almacena como un secreto del repositorio llamado `SONAR_TOKEN`. Este valor no debe escribirse directamente en el código ni publicarse en la documentación.

### Dependabot

Dependabot está configurado para revisar semanalmente las dependencias de:

- Maven.
- Docker.
- GitHub Actions.

Las actualizaciones propuestas se revisan mediante Pull Requests. Antes de fusionarlas, se debe comprobar que las pruebas, el análisis y la construcción de la aplicación continúen funcionando.

También están habilitadas las alertas de Dependabot y las actualizaciones de seguridad.

## 5. Protección de la rama principal

El repositorio utiliza un ruleset llamado `Proteccion-main`, dirigido a la rama principal.

La configuración contempla:

- Exigir Pull Requests antes de incorporar cambios.
- Exigir que pase el check obligatorio de GitHub Actions.
- Evitar los cambios forzados y la eliminación accidental de la rama, si estas restricciones están habilitadas en el ruleset.

El propósito es reducir el riesgo de incorporar cambios que no hayan superado las comprobaciones automatizadas.

## 6. Contenedores y despliegue

El proyecto utiliza Docker para empaquetar la aplicación y Docker Compose para construirla y ejecutarla.

Para iniciar el servicio localmente:

`docker compose up --build`

La aplicación queda disponible en:

- Página principal: `http://localhost:8080/`
- Swagger UI: `http://localhost:8080/swagger-ui/index.html`
- Documentación OpenAPI: `http://localhost:8080/v3/api-docs.yaml`

El pipeline realiza una ejecución temporal del contenedor en el runner de GitHub Actions y comprueba la respuesta de Swagger.

Este procedimiento valida la construcción y el inicio de la aplicación, pero no corresponde a un despliegue permanente en un servidor de producción.

## 7. Verificación del pipeline

Una ejecución satisfactoria debe mostrar que las etapas correspondientes finalizaron correctamente.

Para revisar los resultados:

1. Abrir la pestaña Actions del repositorio.
2. Seleccionar la ejecución del workflow CI - Postulaciones.
3. Revisar el resultado de las pruebas y del análisis de SonarCloud.
4. En las ejecuciones `push`, revisar también la construcción de Docker, la respuesta de Swagger y la detención de los contenedores.
5. Revisar el resultado de las comprobaciones en los Pull Requests antes de fusionarlos.

## 8. Conclusión

La configuración permite automatizar verificaciones importantes del ciclo de desarrollo, detectar problemas antes de integrar cambios, mantener las dependencias bajo revisión y reducir el riesgo de incorporar modificaciones defectuosas a la rama principal.

El despliegue configurado en GitHub Actions es de prueba y temporal. Para disponer de un despliegue permanente sería necesario configurar un entorno de ejecución externo.
