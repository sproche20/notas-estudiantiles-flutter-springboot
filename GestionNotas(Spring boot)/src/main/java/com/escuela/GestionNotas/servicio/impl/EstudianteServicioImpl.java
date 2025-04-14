package com.escuela.GestionNotas.servicio.impl;

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.escuela.GestionNotas.modelo.EstudianteModel;
import com.escuela.GestionNotas.repositorio.EstudianteRepositorio;
import com.escuela.GestionNotas.servicio.EstudianteServicio;

@Service
public class EstudianteServicioImpl implements EstudianteServicio{
@Autowired
EstudianteRepositorio EstudianteRep;
	@Override
	public void insertar(EstudianteModel estudiante) {
		try {
			EstudianteRep.saveAndFlush(estudiante);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<EstudianteModel> listar() {
		// TODO Auto-generated method stub
		return EstudianteRep.findByActivoTrue();
	}

	@Override
	public EstudianteModel buscarPorId(Long id) {
	    return EstudianteRep.findById(id).get();
	}

	@Override
	public void eliminar(Long id) {
		try {
			EstudianteRep.deleteById(id);
		} catch (Exception e) {
			 e.printStackTrace();
		}
		
	}

	@Override
	public List<EstudianteModel> buscarPorCursoId(Long id) {
		// TODO Auto-generated method stub
	    return EstudianteRep.findByFkCursos_IdAndActivoTrue(id);
	}

}
