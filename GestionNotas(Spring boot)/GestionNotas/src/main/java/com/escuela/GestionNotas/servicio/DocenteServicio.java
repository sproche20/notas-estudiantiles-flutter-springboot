package com.escuela.GestionNotas.servicio;

import java.util.List;

import com.escuela.GestionNotas.modelo.DocenteModel;

public interface DocenteServicio {
	public void insertar(DocenteModel Docente );
	public List<DocenteModel>listar();
	public DocenteModel buscarPorId(Long id);
	public void eliminar(Long id);

}
