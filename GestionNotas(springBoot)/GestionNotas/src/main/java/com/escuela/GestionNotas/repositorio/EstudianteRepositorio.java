package com.escuela.GestionNotas.repositorio;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.escuela.GestionNotas.modelo.EstudianteModel;

public interface EstudianteRepositorio  extends JpaRepository<EstudianteModel, Long>{
	List<EstudianteModel> findByFkCursos_Id(Long id);
	 List<EstudianteModel> findByActivoTrue();
	 Optional<EstudianteModel> findByIdAndActivoTrue(Long id);
	 List<EstudianteModel> findByFkCursos_IdAndActivoTrue(Long id);

}
