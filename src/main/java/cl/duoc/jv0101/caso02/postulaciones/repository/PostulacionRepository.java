package cl.duoc.jv0101.caso02.postulaciones.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import cl.duoc.jv0101.caso02.postulaciones.model.Postulacion;

public interface PostulacionRepository extends JpaRepository<Postulacion, Long> {
}
