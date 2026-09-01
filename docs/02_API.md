# Postulaciones — Contrato de la API REST

## Base

- **Base path**: `/api/postulaciones`
- **Formato**: JSON — **Puerto**: 8080 (configurable con `PORT`)

## Recursos

| Método | Ruta | Códigos de estado | Descripción |
|--------|------|-------------------|-------------|
| GET | `/api/postulaciones` | 200 | Lista todos los recursos |
| GET | `/api/postulaciones/{id}` | 200 / 404 | Obtiene un recurso por id |
| POST | `/api/postulaciones` | 201 / 400 | Crea un recurso |
| PUT | `/api/postulaciones/{id}` | 200 / 404 / 400 | Actualiza un recurso |
| DELETE | `/api/postulaciones/{id}` | 204 / 404 | Elimina un recurso |

## Atributos de un recurso

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| id | Long | - | Identificador autogenerado |
| nombre | String | Sí | Nombre del recurso |

| oferta | String | No | Campo del dominio |
| estado | String | No | Campo del dominio |

## Ejemplos con curl

```bash
# Listar
curl http://localhost:8080/api/postulaciones

# Crear
curl -X POST http://localhost:8080/api/postulaciones \
  -H "Content-Type: application/json" \
  -d '{"nombre":"Mi recurso"}'

# Obtener por id
curl http://localhost:8080/api/postulaciones/1

# Actualizar
curl -X PUT http://localhost:8080/api/postulaciones/1 \
  -H "Content-Type: application/json" \
  -d '{"nombre":"Recurso actualizado"}'

# Eliminar
curl -X DELETE http://localhost:8080/api/postulaciones/1
```
