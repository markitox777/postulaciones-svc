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

La auditoria de la imagen Docker no ha sido ejecutada
exitosamente debido al bloqueo previo del repositorio.

El despliegue automatico Kubernetes fue aprobado.
El Quality Gate del Pull Request fue aprobado.
La auditoria de seguridad fue aprobada y el Pull Request quedo habilitado para fusion.

## 11. Justificacion y reflexion individual

Pendiente de completar por el estudiante.

## 12. Declaracion de uso de inteligencia artificial

Completar indicando las herramientas utilizadas,
las actividades en que fueron empleadas y las
verificaciones realizadas personalmente.

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
