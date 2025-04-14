package com.escuela.GestionNotas.servicio.impl;


import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;

import org.springframework.data.domain.Page;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.escuela.GestionNotas.DTO.CalificacionAsigDTO;
import com.escuela.GestionNotas.DTO.NotaAsignaturaDTO;
import com.escuela.GestionNotas.modelo.CalificacionAsignaturaModel;
import com.escuela.GestionNotas.modelo.CalificacionNotaModel;
import com.escuela.GestionNotas.modelo.CalificacionesModel;
import com.escuela.GestionNotas.repositorio.CalificacionesAsignaturaRepositorio;
import com.escuela.GestionNotas.repositorio.CalificacionesRepositorio;
import com.escuela.GestionNotas.servicio.CalificacionesAsignaturaServicio;

@Service
public class CalificacionesAsignaturasServicioImpl implements CalificacionesAsignaturaServicio{
	@Autowired
	CalificacionesRepositorio calRep;
@Autowired  
CalificacionesAsignaturaRepositorio calAsigRep;
@Override
public void insertar(List<CalificacionAsignaturaModel> calificaciones) {
    try {
        for (CalificacionAsignaturaModel calificacion : calificaciones) {
            // Verificar si ya existe alguna calificación para el estudiante y curso
            List<CalificacionAsignaturaModel> existingCalificacion = calAsigRep.findByEstudianteIdAndCursoId(
                    calificacion.getEstudiante().getId(), 
                    calificacion.getCurso().getId());
            
            if (!existingCalificacion.isEmpty()) {
                // Si ya existe, no insertar nuevas calificaciones para este estudiante y curso
                return;  // Aquí podrías lanzar un error o manejarlo según tu lógica
            }
        }
        
        // Si no existen, insertar todas las calificaciones
        calAsigRep.saveAll(calificaciones);

        // Luego de insertar las calificaciones, calcular la nota final
        for (CalificacionAsignaturaModel calificacion : calificaciones) {
            calcularNotaFinal(calificacion.getEstudiante().getId(), calificacion.getCurso().getId());
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}

	@Override
	@Transactional
	public void calcularNotaFinal(Long estudianteId, Long cursoId) {
	    // Obtener todas las calificaciones del estudiante en el curso
	    List<CalificacionAsignaturaModel> calificaciones = calAsigRep.findByEstudianteIdAndCursoId(estudianteId, cursoId);
	    
	    if (!calificaciones.isEmpty()) {
	        // Obtener el promedio de las notas de las calificaciones
	        double promedio = calificaciones.stream()
	            .flatMap(calificacion -> calificacion.getCalificacionesNotas().stream()) // Accede a las notas de la relación
	            .mapToDouble(CalificacionNotaModel::getNota) // Mapea cada nota
	            .average() // Calcula el promedio
	            .orElse(0.0); // Si no hay calificaciones, el promedio será 0

	     // Redondear el promedio a 2 decimales usando BigDecimal
	     BigDecimal promedioConDosDecimales = new BigDecimal(promedio).setScale(2, RoundingMode.HALF_UP);

	     // Establecer la nota final con el promedio redondeado

	        // Buscar si ya existe una calificación final para ese estudiante y curso
	        Optional<CalificacionesModel> notaFinalOpt = calRep.findByEstudianteIdAndCursoId(estudianteId, cursoId);
	        CalificacionesModel notaFinal = notaFinalOpt.orElse(new CalificacionesModel());
	        
	        // Establecer los datos de estudiante y curso en la calificación final
	        if (notaFinal.getEstudiante() == null) {
	            notaFinal.setEstudiante(calificaciones.get(0).getEstudiante());
	        }
	        if (notaFinal.getCurso() == null) {
	            notaFinal.setCurso(calificaciones.get(0).getCurso());
	        }

	        // Actualizar la nota final
		     notaFinal.setNotaFinal(promedioConDosDecimales.doubleValue());
	        
	        // Guardar la calificación final, ya sea nueva o actualizada
	        calRep.save(notaFinal);
	    }
	}
	
	@Override
	public CalificacionAsignaturaModel buscarPorId(Long id) {
		// TODO Auto-generated method stub
		return null;
	}
	@Override
	@Transactional(readOnly = true)
	public Page<CalificacionAsignaturaModel> listarPageable(Pageable pageable) {
		// TODO Auto-generated method stub
		return calAsigRep.findAll(pageable);
	}


	 /** Método para calcular la nota final de un estudiante en un curso */
	@Override
	@Transactional(readOnly = true)
	public List<CalificacionAsignaturaModel> buscarPorEstudianteYCurso(Long estudianteId, Long cursoId) {
	    return calAsigRep.findByEstudianteIdAndCursoId(estudianteId, cursoId);
	}



	@Override
	@Transactional
	public void eliminar(Long id) {
	    // Verificar si la calificación asignatura existe antes de eliminar
	    Optional<CalificacionAsignaturaModel> calificacionOptional = calAsigRep.findById(id);

	    if (calificacionOptional.isPresent()) {
	        // Obtener los datos del estudiante y curso asociados
	        Long estudianteId = calificacionOptional.get().getEstudiante().getId();
	        Long cursoId = calificacionOptional.get().getCurso().getId();

	        // Eliminar la calificación asignatura (esto automáticamente eliminará las calificaciones asociadas)
	        calAsigRep.deleteById(id);

	        // Eliminar la calificación final asociada si existe
	        Optional<CalificacionesModel> notaFinalOptional = calRep.findByEstudianteIdAndCursoId(estudianteId, cursoId);
	        if (notaFinalOptional.isPresent()) {
	            calRep.deleteById(notaFinalOptional.get().getId());
	        }

	    } else {
	        // Si la calificación no se encuentra, imprimir un mensaje en el log
	        System.out.println("La calificación con ID " + id + " no existe.");
	    }
	}




	@Override
	public List<CalificacionAsigDTO> obtenerCalificacionesPorEstudiante(Long estudianteId) {
	    List<CalificacionAsignaturaModel> calificaciones = calAsigRep.findByEstudianteId(estudianteId);

	    return calificaciones.stream().map(c -> {
	        List<NotaAsignaturaDTO> notas = c.getCalificacionesNotas().stream()
	            .filter(n -> n.getAsignatura() != null)
	            .map(n -> new NotaAsignaturaDTO(
	                n.getAsignatura().getId(),
	                n.getNota()
	            ))
	            .toList();

	        return new CalificacionAsigDTO(
	            c.getId(),
	            c.getEstudiante().getId(),
	            c.getCurso().getId(),
	            notas
	        );
	    }).toList();
	}


}
