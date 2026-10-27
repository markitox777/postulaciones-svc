package cl.duoc.jv0101.caso02.postulaciones.dto;

import jakarta.validation.constraints.NotBlank;

/**
 * Datos de entrada para crear o actualizar una postulacion.
 * Se usa en lugar de la entidad JPA en los endpoints, para que el cliente
 * solo pueda enviar los campos permitidos (evita "mass assignment" del id u otros campos).
 */
public record PostulacionRequest(
        @NotBlank(message = "El nombre es obligatorio") String nombre,
        String oferta,
        String estado) {
}
