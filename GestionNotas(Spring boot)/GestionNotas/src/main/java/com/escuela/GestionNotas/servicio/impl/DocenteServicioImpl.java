package com.escuela.GestionNotas.servicio.impl;

import java.util.List;

import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.escuela.GestionNotas.modelo.DocenteModel;
import com.escuela.GestionNotas.repositorio.DocenteRepositorio;
import com.escuela.GestionNotas.servicio.DocenteServicio;

import jakarta.transaction.Transactional;

@Service
public class DocenteServicioImpl implements DocenteServicio{
@Autowired
private DocenteRepositorio docenteRep;
	@Override
	public void insertar(DocenteModel Docente) {
		// TODO Auto-generated method stub
		try {
			docenteRep.save(Docente);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
	}

	@Override
    @Transactional
	public List<DocenteModel> listar() {
		List<DocenteModel>docentes=docenteRep.findAll();
		for(DocenteModel docente:docentes) 
		{
			if (docente.getFkAsignatura()!=null) {
				Hibernate.initialize(docente.getFkAsignatura());
			}
		}
		// TODO Auto-generated method stub
		return docentes;
	}

	@Override
	public DocenteModel buscarPorId(Long id) {
		// TODO Auto-generated method stub
		return docenteRep.findById(id).get();
	}

	@Override
	public void eliminar(Long id) {
		// TODO Auto-generated method stub
		try {
			docenteRep.deleteById(id);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
	}

}
