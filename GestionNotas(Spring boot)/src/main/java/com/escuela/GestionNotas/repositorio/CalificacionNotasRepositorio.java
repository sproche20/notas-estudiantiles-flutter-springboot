package com.escuela.GestionNotas.repositorio;

import org.springframework.data.jpa.repository.JpaRepository;

import com.escuela.GestionNotas.modelo.CalificacionNotaModel;

public interface CalificacionNotasRepositorio extends JpaRepository<CalificacionNotaModel,Long>{

}
