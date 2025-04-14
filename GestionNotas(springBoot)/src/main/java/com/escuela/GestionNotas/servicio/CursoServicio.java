package com.escuela.GestionNotas.servicio;

import java.util.List;

import com.escuela.GestionNotas.modelo.CursoModel;

public interface CursoServicio {
	public void insertar(CursoModel Curso );
	public List<CursoModel>listar();
	public CursoModel buscarPorId(Long id);
	public void eliminar(Long id);
}
