package cl.duoc.jv0101.caso02.postulaciones.service;

import java.util.List;
import java.util.Optional;
import org.springframework.stereotype.Service;
import cl.duoc.jv0101.caso02.postulaciones.model.Postulacion;
import cl.duoc.jv0101.caso02.postulaciones.repository.PostulacionRepository;

@Service
public class PostulacionService {

    private final PostulacionRepository repository;

    public PostulacionService(PostulacionRepository repository) {
        this.repository = repository;
    }

    public List<Postulacion> findAll() {
        return repository.findAll();
    }

    public Optional<Postulacion> findById(Long id) {
        return repository.findById(id);
    }

    public Postulacion create(Postulacion recurso) {
        return repository.save(recurso);
    }

    public Optional<Postulacion> update(Long id, Postulacion datos) {
        return repository.findById(id).map(existente -> {
            existente.setNombre(datos.getNombre());
            existente.setOferta(datos.getOferta());
            existente.setEstado(datos.getEstado());
            return repository.save(existente);
        });
    }

    public boolean delete(Long id) {
        return repository.findById(id).map(existente -> {
            repository.delete(existente);
            return true;
        }).orElse(false);
    }
}
