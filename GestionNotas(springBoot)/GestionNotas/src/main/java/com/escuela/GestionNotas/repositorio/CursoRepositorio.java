package com.escuela.GestionNotas.repositorio;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.escuela.GestionNotas.modelo.CursoModel;

public interface CursoRepositorio extends JpaRepository<CursoModel, Long>{
	@Query("SELECT c FROM CursoModel c LEFT JOIN FETCH c.fkDocente")
	 List<CursoModel> findAllWithDocente();
	 @Query("SELECT COUNT(c) > 0 FROM CursoModel c WHERE c.fkDocente.id = :docenteId")
	    boolean existsByFkDocenteId(@Param("docenteId") Long docenteId);
	
}
