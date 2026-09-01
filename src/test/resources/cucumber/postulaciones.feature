# language: es
Característica: Servicio Postulaciones (microservicio postulaciones del caso caso02)
  Los escenarios validan el contrato REST del microservicio alineado a sus endpoints.

  Escenario: el listado del recurso responde 200
    Dado el servicio "Postulaciones" está disponible
    Cuando consulto el listado de "postulaciones"
    Entonces el listado responde con código 200

  Escenario: ciclo de vida completo del recurso
    Dado un nuevo "postulacion" con nombre "hola-cucumber"
    Cuando consulto el "postulacion" recién creado
    Entonces el recurso tiene nombre "hola-cucumber" y código 200
    Cuando actualizo el "postulacion" con nombre "cucumber-actualizado"
    Entonces el recurso queda con nombre "cucumber-actualizado" y código 200
    Cuando elimino el "postulacion"
    Entonces la eliminación responde con código 204
    Y al consultar el "postulacion" eliminado responde 404
