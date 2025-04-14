package com.escuela.GestionNotas.servicio;


import com.escuela.GestionNotas.modelo.CalificacionesModel;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Page;

public interface CalificacionesServicio {
	public void insertar(CalificacionesModel Calificaciones );
	public CalificacionesModel buscarPorId(Long id);
	public void eliminar(Long id);
	Page<CalificacionesModel>listarPageable(Pageable pageable);
    
}
