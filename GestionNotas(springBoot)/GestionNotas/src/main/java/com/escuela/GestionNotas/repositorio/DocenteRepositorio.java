package com.escuela.GestionNotas.repositorio;

import org.springframework.data.jpa.repository.JpaRepository;

import com.escuela.GestionNotas.modelo.DocenteModel;

public interface DocenteRepositorio extends JpaRepository<DocenteModel, Long>{

}
