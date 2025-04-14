package com.escuela.GestionNotas.repositorio;


import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.escuela.GestionNotas.modelo.CalificacionAsignaturaModel;
import com.escuela.GestionNotas.modelo.CalificacionesModel;

public interface CalificacionesRepositorio extends JpaRepository<CalificacionesModel, Long>{
	@Query("SELECT c FROM CalificacionesModel c " +
		       "LEFT JOIN FETCH c.estudiante " +
		       "LEFT JOIN FETCH c.curso")
		Page<CalificacionesModel> findAllWithEstudianteAndCurso(Pageable pageable);
	Optional<CalificacionesModel> findByEstudianteIdAndCursoId(@Param("estudianteId") Long estudianteId, 
            @Param("cursoId") Long cursoId);

}
