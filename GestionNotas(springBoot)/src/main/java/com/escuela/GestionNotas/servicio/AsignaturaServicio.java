package com.escuela.GestionNotas.servicio;

import java.util.List;

import com.escuela.GestionNotas.modelo.AsignaturaModel;


public interface AsignaturaServicio {
	public void insertar(AsignaturaModel Asignatura );
	public List<AsignaturaModel>listar();
	public AsignaturaModel buscarPorId(Long id);
	public void eliminar(Long id);
}
