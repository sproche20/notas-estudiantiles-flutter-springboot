package com.escuela.GestionNotas.servicio;

import java.util.List;

import com.escuela.GestionNotas.modelo.EstudianteModel;

public interface EstudianteServicio {
	public void insertar(EstudianteModel estudiante);
	public List<EstudianteModel>listar();
	public List<EstudianteModel> buscarPorCursoId(Long id);
	public EstudianteModel buscarPorId(Long id);
	public void eliminar(Long id);
}
