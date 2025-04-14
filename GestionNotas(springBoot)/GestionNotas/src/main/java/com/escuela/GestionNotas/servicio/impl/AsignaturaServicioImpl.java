package com.escuela.GestionNotas.servicio.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.escuela.GestionNotas.modelo.AsignaturaModel;
import com.escuela.GestionNotas.repositorio.AsignaturaRepositorio;
import com.escuela.GestionNotas.servicio.AsignaturaServicio;

@Service
public class AsignaturaServicioImpl implements AsignaturaServicio{
@Autowired
private AsignaturaRepositorio asignaturaRep;
	@Override
	public void insertar(AsignaturaModel Asignatura) {
		// TODO Auto-generated method stub
		try {
			asignaturaRep.save(Asignatura);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}

	@Override
	public List<AsignaturaModel> listar() {
		// TODO Auto-generated method stub
		return asignaturaRep.findAll();
	}

	@Override
	public AsignaturaModel buscarPorId(Long id) {
		// TODO Auto-generated method stub
		return asignaturaRep.findById(id).get();
	}

	@Override
	public void eliminar(Long id) {
		// TODO Auto-generated method stub
		try {
			asignaturaRep.deleteById(id);
		} catch (Exception e) {
			// TODO: handle exception
			 e.printStackTrace();
			
		}
		
	}

}
