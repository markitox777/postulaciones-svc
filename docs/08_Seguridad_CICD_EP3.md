# EP3 - Seguridad, calidad y CI/CD

## 1. Herramientas

- GitHub Actions.
- SonarCloud.
- JaCoCo.
- Trivy.
- Dependabot.

## 2. Politicas automatizadas

- Ejecucion de pruebas automatizadas.
- Cobertura minima de lineas del 100% segun JaCoCo.
- Analisis de calidad mediante SonarCloud.
- Auditoria de vulnerabilidades mediante Trivy.
- Bloqueo ante vulnerabilidades criticas.
- Proteccion de la rama main mediante status checks.

## 3. Auditoria inicial

Trivy detecto nueve vulnerabilidades criticas.

El pipeline finalizo con codigo de salida 1,
impidiendo ejecutar el despliegue Kubernetes.

## 4. Correcciones aplicadas

| Dependencia | Antes | Despues |
|---|---|---|
| Spring Boot | 3.3.5 | 3.5.16 |
| Tomcat | 10.1.31 | 10.1.62 |
| Spring WebMVC | 6.1.14 | 6.2.19 |

## 5. Resultados posteriores

- 20 pruebas aprobadas.
- 0 errores en las pruebas.
- Control de cobertura aprobado.
- Pipeline de integracion continua exitoso.
- Reduccion de 9 a 2 vulnerabilidades criticas.
- Reduccion neta del 77,8%.

## 6. Vulnerabilidades detectadas en la segunda auditoria

- CVE-2026-47884.
- CVE-2026-47890.

Trivy identifica Spring WebMVC 7.0.9 como version
correctiva. La migracion requiere evaluar compatibilidad
con Spring Boot y las pruebas existentes.

## 7. Bloqueo automatico

La politica de seguridad permanece activa.

El pipeline de seguridad impide ejecutar el despliegue
cuando la auditoria detecta vulnerabilidades criticas.

No se deshabilito el control para permitir el despliegue.

## 8. Proteccion de main

Comprobaciones obligatorias configuradas:

- Pruebas, SonarQube y Docker.
- Auditoria de seguridad.

Los cambios deben pasar los controles requeridos
antes de fusionarse mediante Pull Request.

## 9. Evidencias

- [Auditoria inicial](evidencias/auditoria-repositorio-antes.txt)
- [Auditoria posterior](evidencias/auditoria-repositorio-despues.txt)
- [Bloqueo inicial](evidencias/bloqueo-seguridad.txt)
- [Bloqueo posterior](evidencias/bloqueo-seguridad-despues.txt)
- [Pruebas posteriores](evidencias/pruebas-despues-actualizacion.txt)
- [Dependencias actualizadas](evidencias/dependencias-actualizadas.txt)

## 10. Limitaciones

La auditoria del repositorio, la imagen Docker y las seis
imagenes de monitoreo fue ejecutada exitosamente.
El alcance bloqueante corresponde a severidad CRITICAL.

El despliegue automatico Kubernetes fue aprobado.
El Quality Gate del Pull Request fue aprobado.
La auditoria de seguridad fue aprobada en ejecuciones anteriores.
El estado actual del Pull Request debe comprobarse antes de fusionar.

## 11. Justificacion y reflexion individual

1. ¿Por qué utilizar SonarCloud y Trivy?
R: SonarCloud nos permite analizar automáticamente la calidad del código fuente, identificando problemas de seguridad, mantenibilidad y fiabilidad. Su Quality Gate permite comprobar si el código cumple las condiciones de calidad establecidas.
Por otra parte, Trivy nos permite detectar vulnerabilidades conocidas en las dependencias del proyecto y las imágenes Docker. Ambas herramientas se complementan, ya que SonarCloud analiza principalmente el código fuente y Trivy permite identificar riesgos asociados a los componentes y dependencias utilizados por la aplicación.
2. ¿Qué problema real de seguridad se detectó y cómo se solucionó?
R: Durante las primeras ejecuciones del pipeline, Trivy detectó nueve hallazgos críticos relacionados con las dependencias de Spring Boot y Tomcat.
Inicialmente, se actualizó Spring Boot a la versión 3.5.16, reduciendo los hallazgos críticos de nueve a dos. Posteriormente, se realizó una migración a Spring Boot 4.0.10, adaptando las dependencias y las pruebas automatizadas.
También se detectaron 20 hallazgos críticos acumulados en las imágenes de las herramientas de monitoreo, por lo que se actualizaron sus versiones.
Después de realizar estas modificaciones, las auditorías críticas finalizaron correctamente, las 20 pruebas automatizadas fueron aprobadas y se mantuvo el 100% de cobertura de líneas.
3. ¿Por qué implementar políticas de cumplimiento automatizadas?
R: Las políticas automatizadas nos permiten establecer condiciones obligatorias que deben cumplirse antes de aprobar cambios o desplegar el microservicio.
En el proyecto se utilizamos SonarCloud para controlar la calidad del código, Trivy para detectar vulnerabilidades críticas, JaCoCo para verificar la cobertura de pruebas y Dependabot para detectar actualizaciones disponibles.
Además, se configuraron reglas de protección sobre la rama main, evitando que los cambios sean fusionados mientras existan controles obligatorios fallidos.
También se incorporó una verificación mediante SHA-256 para comprobar la integridad del archivo que contiene la imagen Docker auditada antes de desplegarla.
4. ¿Qué sucede cuando se detecta una falla crítica?
R: Cuando Trivy detecta una vulnerabilidad crítica, devuelve un código de salida de error, provocando que GitHub Actions marque la auditoría como fallida y detenga el despliegue dependiente de esa auditoría.
Esta situación ocurrió durante el desarrollo, cuando las vulnerabilidades detectadas impidieron continuar con el despliegue de Kubernetes.
Una vez corregidos los problemas y ejecutadas nuevamente las verificaciones, los siete controles del Pull Request finalizaron exitosamente, permitiendo que quedara habilitado para su fusión.
5. ¿Qué limitaciones tiene la seguridad implementada?
R: La política actual de Trivy bloquea vulnerabilidades de severidad crítica, pero esto nos garantiza que el sistema esté completamente libre de vulnerabilidades de otras severidades.
Como posibles mejoras futuras podriamos incorporar auditorías de configuraciones de Kubernetes, análisis dinámico de seguridad, políticas de bloqueo para vulnerabilidades altas y fijación de imágenes mediante sus identificadores digest.
Estas mejoras son propuestas, no funcionalidades que hayamos verificado como implementadas.

## 12. Declaracion de uso de inteligencia artificial

Durante el desarrollo del proyecto se utilizó ChatGPT, herramienta de inteligencia artificial desarrollada por OpenAI, como apoyo para comprender conceptos técnicos, generar código, configurar herramientas de observabilidad, elaborar archivos YAML, desarrollar scripts de automatización, configurar pipelines CI/CD, resolver errores y estructurar la documentación técnica.

Los resultados fueron comprobados mediante ejecuciones de pruebas automatizadas, auditorías de seguridad, consultas de métricas, revisión de registros y validaciones realizadas en GitHub Actions y Kubernetes.

**Referencia:**

OpenAI. (2026). ChatGPT [Modelo de lenguaje de inteligencia artificial]. https://chatgpt.com/

## 13. Correccion del Quality Gate

SonarCloud detecto tres problemas de seguridad relacionados
con referencias modificables de acciones externas.

Se fijaron las referencias de Trivy y Setup Minikube
mediante SHA completos de sus commits.

Commit de correccion: 434b163.

Resultados posteriores:

- Analisis SonarCloud aprobado.
- Integracion continua aprobada.
- Auditoria Trivy bloqueada en esa etapa del proyecto.
- Despliegue Kubernetes omitido en esa ejecucion historica.

Evidencias:

- [Comprobaciones finales](evidencias/pull-request-checks-final.txt)
- [Estado final del PR](evidencias/pull-request-estado-final.json)

## 14. Migracion final a Spring Boot 4

La migracion fue registrada en el commit 88c052d.

| Dependencia | Version anterior | Version final |
|---|---|---|
| Spring Boot | 3.5.16 | 4.0.10 |
| Spring WebMVC | 6.2.19 | 7.0.11 |
| Tomcat | 10.1.62 | 11.0.27 |
| Springdoc | 2.6.0 | 3.0.3 |

### Evolucion de las auditorias

| Etapa | Vulnerabilidades criticas detectadas |
|---|---:|
| Auditoria inicial | 9 |
| Primera actualizacion | 2 |
| Migracion final | 0 |

### Resultados verificados

- 20 pruebas automatizadas aprobadas.
- Cobertura JaCoCo del 100%.
- Auditoria del repositorio aprobada.
- Auditoria de imagen Docker aprobada.
- Quality Gate aprobado.
- Siete controles de GitHub aprobados.
- Despliegue automatico Kubernetes exitoso.
- Pull Request en estado CLEAN.

### Evidencias

- [Auditoria final del repositorio](evidencias/auditoria-repositorio-final.txt)
- [Auditoria final de imagen](evidencias/auditoria-imagen-final.txt)
- [Pruebas de migracion](evidencias/migracion-spring-boot4-pruebas.txt)
- [Controles aprobados](evidencias/pull-request-aprobado.txt)
- [Pipeline exitoso](evidencias/pipeline-seguridad-aprobado.txt)

Ejecucion de seguridad: 45482303285.

La auditoria acredita cero vulnerabilidades dentro del
alcance CRITICAL configurado. No garantiza la ausencia
de vulnerabilidades de otras severidades ni acredita
el analisis de secretos.


## 15. Auditoria de componentes de monitoreo

La ampliacion de la auditoria detecto 20 hallazgos
criticos en las imagenes de monitoreo.

El pipeline bloqueo automaticamente el despliegue.

Se actualizaron las siguientes imagenes:

| Componente | Version anterior | Version final |
|---|---|---|
| Alloy | 1.9.2 | 1.22.0 |
| Grafana | 12.3.0 | 13.3.2 |
| Loki | 3.5.0 | 3.7.10 |
| Tempo | 2.8.2 | 3.1.1 |
| Node Exporter | 1.9.1 | 1.13.1 |
| Prometheus | 3.5.0 | 3.16.0 |

La configuracion de Tempo fue migrada para mantener
compatibilidad con la nueva version.

La auditoria posterior fue aprobada sin hallazgos
criticos bloqueantes reportados.

- [Auditorias anteriores](evidencias/seguridad-monitoreo/antes/)
- [Evidencia de bloqueo](evidencias/seguridad-monitoreo/bloqueo.txt)
- [Auditorias finales](evidencias/final/seguridad/)

## 16. Integridad de la imagen desplegada

La imagen auditada del microservicio se transfiere
entre trabajos de GitHub Actions mediante un artefacto.

La integridad del archivo se comprueba mediante SHA-256
antes de cargarlo y desplegarlo en Kubernetes.

Las imagenes de monitoreo se auditan por sus etiquetas
de version, que no constituyen referencias inmutables.

## 17. Incidencia externa de Maven Central

La ejecucion 45518988992 fallo durante la construccion
Docker debido a una respuesta HTTP 429 de Maven Central.

La ejecucion del Pull Request 45518995718 completo
correctamente todas las etapas de seguridad y despliegue.

El fallo HTTP 429 no corresponde a una vulnerabilidad
detectada ni a un fallo de las pruebas automatizadas.

- [Registro del error](evidencias/final/error-temporal-maven.txt)
- [Pipeline aprobado](evidencias/final/pipeline-aprobado.txt)

## 18. Alcance de la validacion final

- Auditoria del repositorio aprobada.
- Auditoria de imagen del microservicio aprobada.
- Auditoria de seis imagenes de monitoreo aprobada.
- Verificacion SHA-256 aprobada.
- Despliegue automatico aprobado.
- Verificaciones de metricas, logs y trazas aprobadas.

La auditoria no garantiza ausencia de vulnerabilidades
de otras severidades ni acredita por si sola una
verificacion completa de secretos.

El trabajo de despliegue depende de la auditoria de
seguridad. SonarCloud se ejecuta en un workflow separado
y participa en los controles requeridos para fusionar.
