package com.escuela.GestionNotas.servicio;

import org.springframework.data.domain.Pageable;

import java.util.List;

import org.springframework.data.domain.Page;

import com.escuela.GestionNotas.DTO.CalificacionAsigDTO;
import com.escuela.GestionNotas.modelo.CalificacionAsignaturaModel;

public interface CalificacionesAsignaturaServicio {
	public void insertar(List<CalificacionAsignaturaModel> calificaciones);

	public CalificacionAsignaturaModel buscarPorId(Long id);
	public void eliminar(Long id);
	 Page<CalificacionAsignaturaModel> listarPageable(Pageable pageable);
		// Método para calcular la nota final
	    void calcularNotaFinal(Long estudianteId, Long cursoId);
	    public List<CalificacionAsignaturaModel> buscarPorEstudianteYCurso(Long estudianteId, Long cursoId);
	    public List<CalificacionAsigDTO> obtenerCalificacionesPorEstudiante(Long estudianteId);
}
