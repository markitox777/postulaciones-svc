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

## 6. Vulnerabilidades pendientes

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

El despliegue automatico Kubernetes permanece bloqueado.
El Quality Gate del Pull Request final esta pendiente
de validacion.

## 11. Justificacion y reflexion individual

Pendiente de completar por el estudiante.

## 12. Declaracion de uso de inteligencia artificial

Completar indicando las herramientas utilizadas,
las actividades en que fueron empleadas y las
verificaciones realizadas personalmente.
