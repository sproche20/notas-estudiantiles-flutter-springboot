package com.escuela.GestionNotas.repositorio;

import org.springframework.data.jpa.repository.JpaRepository;

import com.escuela.GestionNotas.modelo.AsignaturaModel;

public interface AsignaturaRepositorio extends JpaRepository<AsignaturaModel,Long>{

}
