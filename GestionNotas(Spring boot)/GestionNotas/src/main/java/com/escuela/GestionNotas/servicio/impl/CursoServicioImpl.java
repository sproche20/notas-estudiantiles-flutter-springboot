package com.escuela.GestionNotas.servicio.impl;

import java.util.List;

import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.escuela.GestionNotas.modelo.CursoModel;
import com.escuela.GestionNotas.repositorio.CursoRepositorio;
import com.escuela.GestionNotas.servicio.CursoServicio;

@Service
public class CursoServicioImpl implements CursoServicio{
@Autowired
CursoRepositorio cursoRep;
	@Override
	public void insertar(CursoModel Curso) {
		// TODO Auto-generated method stub
		try {
			cursoRep.save(Curso);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}

	@Override
	public List<CursoModel> listar() {
		return cursoRep.findAllWithDocente();
	}

	@Override
	public CursoModel buscarPorId(Long id) {
		// TODO Auto-generated method stub
		return cursoRep.findById(id).orElseThrow(() -> new RuntimeException("Curso no encontrado"));
	}

	@Override
	public void eliminar(Long id) {
	    if (cursoRep.existsById(id)) {
	        cursoRep.deleteById(id);
	    } else {
	        System.out.println("El curso con ID " + id + " no existe.");
	    }
	}
}
