package com.escuela.GestionNotas.repositorio;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.escuela.GestionNotas.modelo.CalificacionAsignaturaModel;


public interface CalificacionesAsignaturaRepositorio extends JpaRepository<CalificacionAsignaturaModel, Long> {
	List<CalificacionAsignaturaModel> findByEstudianteId(Long id);

	@Query("SELECT c FROM CalificacionAsignaturaModel c " +
		       "LEFT JOIN FETCH c.estudiante " +
		       "LEFT JOIN FETCH c.curso " 
		      )
		Page<CalificacionAsignaturaModel> findAllWithEstudianteCursoAsignatura(Pageable pageable);
	@Query("SELECT c FROM CalificacionAsignaturaModel c " +
	           "WHERE c.estudiante.id = :estudianteId AND c.curso.id = :cursoId")
	    List<CalificacionAsignaturaModel> findByEstudianteIdAndCursoId(@Param("estudianteId") Long estudianteId, 
	                                                                   @Param("cursoId") Long cursoId);
}