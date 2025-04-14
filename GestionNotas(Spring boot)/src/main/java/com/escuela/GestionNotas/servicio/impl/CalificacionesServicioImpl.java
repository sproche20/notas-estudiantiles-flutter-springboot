package com.escuela.GestionNotas.servicio.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.escuela.GestionNotas.modelo.CalificacionAsignaturaModel;
import com.escuela.GestionNotas.modelo.CalificacionesModel;
import com.escuela.GestionNotas.repositorio.CalificacionesAsignaturaRepositorio;
import com.escuela.GestionNotas.repositorio.CalificacionesRepositorio;
import com.escuela.GestionNotas.servicio.CalificacionesServicio;

@Service
public class CalificacionesServicioImpl implements CalificacionesServicio{
@Autowired
CalificacionesRepositorio calRep;
@Autowired
private CalificacionesAsignaturaRepositorio calAsigRep;
	@Override
	public void insertar(CalificacionesModel Calificaciones) {
		// TODO Auto-generated method stub
		try {
			calRep.save(Calificaciones);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
	}
	@Override
	public CalificacionesModel buscarPorId(Long id) {
		// TODO Auto-generated method stub
		return calRep.findById(id).orElseThrow(() -> new RuntimeException("Calificacion no encontrado"));
	}

	@Override
	public void eliminar(Long id) {
		// TODO Auto-generated method stub
		if (calRep.existsById(id)) {
			calRep.deleteById(id);
		}else 
		{
	        System.out.println("la calificacion con ID " + id + " no existe.");

		}
		
	}
	@Override
	@Transactional(readOnly = true)
	public Page<CalificacionesModel> listarPageable(Pageable pageable) {
		// TODO Auto-generated method stub
		return calRep.findAll(pageable);
	}
	
}
