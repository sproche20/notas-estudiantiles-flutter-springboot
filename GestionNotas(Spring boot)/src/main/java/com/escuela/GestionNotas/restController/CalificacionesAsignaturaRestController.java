package com.escuela.GestionNotas.restController;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.escuela.GestionNotas.DTO.CalificacionAsigDTO;
import com.escuela.GestionNotas.DTO.CalificacionesDTO;
import com.escuela.GestionNotas.DTO.NotaAsignaturaDTO;
import com.escuela.GestionNotas.modelo.AsignaturaModel;
import com.escuela.GestionNotas.modelo.CalificacionAsignaturaModel;
import com.escuela.GestionNotas.modelo.CalificacionNotaModel;
import com.escuela.GestionNotas.modelo.CalificacionesModel;
import com.escuela.GestionNotas.modelo.CursoModel;
import com.escuela.GestionNotas.modelo.EstudianteModel;
import com.escuela.GestionNotas.repositorio.AsignaturaRepositorio;
import com.escuela.GestionNotas.repositorio.CalificacionesAsignaturaRepositorio;
import com.escuela.GestionNotas.repositorio.CalificacionesRepositorio;
import com.escuela.GestionNotas.repositorio.CursoRepositorio;
import com.escuela.GestionNotas.repositorio.EstudianteRepositorio;
import com.escuela.GestionNotas.servicio.AsignaturaServicio;
import com.escuela.GestionNotas.servicio.CalificacionesAsignaturaServicio;
import com.escuela.GestionNotas.servicio.CursoServicio;
import com.escuela.GestionNotas.servicio.EstudianteServicio;

@RestController
@RequestMapping("gestion-notas/notas-asignatura")
public class CalificacionesAsignaturaRestController {
	@Autowired
	private CalificacionesAsignaturaServicio calAsigServ;
	@Autowired
	private AsignaturaServicio asignaturaServ;
	@Autowired AsignaturaRepositorio asignaturaRepository;
	@Autowired
	private CalificacionesAsignaturaRepositorio calificacionRepo;
	@Autowired
	private CursoServicio cursoServ;
	@Autowired
	private EstudianteServicio estServ;
	@Autowired
	private EstudianteRepositorio estudianteRepo;
	@Autowired
	private CursoRepositorio cursoRepo;
	@Autowired
	private CalificacionesRepositorio calFinalRep;
	@GetMapping
	public ResponseEntity<Page<CalificacionAsigDTO>> obtenerCalificacionesAsignatura(
	       @RequestParam(defaultValue = "0") int page,
	       @RequestParam(defaultValue = "10") int size,
	       @RequestParam(defaultValue = "id") String sortBy) {

	    Pageable pageable = PageRequest.of(page, size, Sort.by(sortBy));
	    Page<CalificacionAsignaturaModel> calificaciones = calAsigServ.listarPageable(pageable);

	    Page<CalificacionAsigDTO> dtoPage = calificaciones.map(ca -> {
	        Map<Long, Double> notasMap = new HashMap<>();  // Mapa para evitar duplicados

	        List<CalificacionAsignaturaModel> calificacionesEstudiante = calAsigServ.buscarPorEstudianteYCurso(
	                ca.getEstudiante().getId(), ca.getCurso().getId());

	        // Agrupar notas por asignatura para evitar duplicados
	        for (CalificacionAsignaturaModel calificacion : calificacionesEstudiante) {
	            for (CalificacionNotaModel calificacionNota : calificacion.getCalificacionesNotas()) {
	                Long asignaturaId = calificacionNota.getAsignatura().getId();
	                Double nota = calificacionNota.getNota() != null ? calificacionNota.getNota() : 0.0;
	                
	                // Si ya existe una nota para esta asignatura, actualizar la nota (si es necesario)
	                if (notasMap.containsKey(asignaturaId)) {
	                    // Aquí puedes elegir cómo manejar duplicados o tomar el promedio si es necesario.
	                    // Actualmente, solo mantiene la última nota agregada.
	                    notasMap.put(asignaturaId, nota);
	                } else {
	                    notasMap.put(asignaturaId, nota);
	                }
	            }
	        }

	        // Crear lista de DTOs para las notas sin duplicados
	        List<NotaAsignaturaDTO> notas = new ArrayList<>();
	        for (Map.Entry<Long, Double> entry : notasMap.entrySet()) {
	            notas.add(new NotaAsignaturaDTO(entry.getKey(), entry.getValue()));
	        }

	        return new CalificacionAsigDTO(
	                ca.getId(),
	                ca.getEstudiante().getId(),
	                ca.getCurso().getId(),
	                notas
	        );
	    });

	    return ResponseEntity.ok(dtoPage);
	}

	//guardar nota por asignatura
	@PostMapping
	public ResponseEntity<?> guardarCalificaciones(@RequestBody CalificacionAsigDTO calificacionDTO) {
	    try {
	        // Obtener estudiante y curso desde la base de datos
	        EstudianteModel estudiante = estudianteRepo.findById(calificacionDTO.getFkEstudiante()).orElse(null);
	        CursoModel curso = cursoRepo.findById(calificacionDTO.getFkCurso()).orElse(null);

	        if (estudiante == null || curso == null) {
	            return ResponseEntity.badRequest().body("Estudiante o curso no encontrados.");
	        }

	        // Verificar si ya existen calificaciones para este estudiante y curso
	        List<CalificacionAsignaturaModel> calificacionesExistentes = calificacionRepo.findByEstudianteIdAndCursoId(estudiante.getId(), curso.getId());
	        if (!calificacionesExistentes.isEmpty()) {
	            return ResponseEntity.badRequest().body("Ya existen calificaciones para este estudiante en este curso.");
	        }

	        // Crear las nuevas calificaciones si no existen
	        CalificacionAsignaturaModel calificacion = new CalificacionAsignaturaModel();
	        calificacion.setEstudiante(estudiante);
	        calificacion.setCurso(curso);

	        List<CalificacionNotaModel> notas = new ArrayList<>();
	        for (NotaAsignaturaDTO notaDTO : calificacionDTO.getNotas()) {
	            AsignaturaModel asignatura = asignaturaRepository.findById(notaDTO.getFkAsignatura()).orElse(null);
	            if (asignatura != null) {
	                CalificacionNotaModel nuevaNota = new CalificacionNotaModel();
	                nuevaNota.setCalificacionAsignatura(calificacion); // Establecer la relación con la calificación
	                nuevaNota.setAsignatura(asignatura);
	                nuevaNota.setNota(notaDTO.getNota());
	                notas.add(nuevaNota);
	                
	            }
	            
	        }
	        calificacion.setCalificacionesNotas(notas); // Establecer las notas en la calificación
	        
	        calificacionRepo.save(calificacion); // Guardar la calificación
	        calAsigServ.calcularNotaFinal(estudiante.getId(), curso.getId());

	        return ResponseEntity.status(HttpStatus.CREATED).body("Calificaciones registradas correctamente.");
	    } catch (Exception e) {
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error al guardar las calificaciones: " + e.getMessage());
	    }
	}
	//buscar por id
	@GetMapping("/{id}")
	public ResponseEntity<CalificacionAsignaturaModel> obtenerCalificacionAsignaturaPorId(@PathVariable("id")Long id) {
		CalificacionAsignaturaModel calificaciones=calAsigServ.buscarPorId(id);
		return (calificaciones!=null)?ResponseEntity.ok(calificaciones):ResponseEntity.notFound().build();
	
	}



	@PutMapping("/{idCalificacion}")
	public ResponseEntity<?> actualizarCalificaciones(
	        @PathVariable("idCalificacion") Long idCalificacion,
	        @RequestBody CalificacionAsigDTO calificacionDTO) {
	    try {
	        Optional<CalificacionAsignaturaModel> calificacionOptional = calificacionRepo.findById(idCalificacion);

	        if (!calificacionOptional.isPresent()) {
	            return ResponseEntity.badRequest().body("Calificación no encontrada.");
	        }

	        CalificacionAsignaturaModel calificacion = calificacionOptional.get();

	        // Actualizar o agregar las calificaciones
	        for (NotaAsignaturaDTO notaDTO : calificacionDTO.getNotas()) {
	            Long asignaturaId = notaDTO.getFkAsignatura();
	            Double nuevaNota = notaDTO.getNota();

	            // Buscar si la asignatura ya existe en las calificaciones
	            CalificacionNotaModel calificacionNotaExistente = calificacion.getCalificacionesNotas().stream()
	                    .filter(c -> c.getAsignatura().getId().equals(asignaturaId))
	                    .findFirst()
	                    .orElse(null);

	            if (calificacionNotaExistente != null) {
	                // Si ya existe, actualizamos la nota
	                calificacionNotaExistente.setNota(nuevaNota);
	            } else {
	                // Si no existe, creamos una nueva calificación
	                AsignaturaModel asignatura = asignaturaRepository.findById(asignaturaId).orElse(null);
	                if (asignatura == null) {
	                    return ResponseEntity.badRequest().body("Asignatura no encontrada.");
	                }
	                CalificacionNotaModel nuevaNotaModel = new CalificacionNotaModel();
	                nuevaNotaModel.setCalificacionAsignatura(calificacion);  // Asociación correcta
	                nuevaNotaModel.setAsignatura(asignatura);
	                nuevaNotaModel.setNota(nuevaNota);
	                calificacion.getCalificacionesNotas().add(nuevaNotaModel);  // Agregar a la lista
	            }
	        }
	        calificacionRepo.save(calificacion);  // Guardar la calificación con las notas actualizadas
	     // Ahora actualizamos la nota final en la otra tabla
	        // Llamamos al servicio para calcular la nueva nota final
	        calAsigServ.calcularNotaFinal(calificacion.getEstudiante().getId(), calificacion.getCurso().getId());    
	        return ResponseEntity.ok("Calificaciones actualizadas correctamente.");
	    } catch (Exception e) {
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
	                .body("Error al actualizar las calificaciones: " + e.getMessage());
	    }
	}





	@DeleteMapping("/{id}")
	public ResponseEntity<String> eliminarCalificacionAsignaturas(@PathVariable("id") Long id) {
		 try {
		        // Buscar la calificación por asignatura
		        Optional<CalificacionAsignaturaModel> calificacionOptional = calificacionRepo.findById(id);

		        if (!calificacionOptional.isPresent()) {
		            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Calificación no encontrada.");
		        }

		        // Obtener los datos del estudiante y curso
		        Long estudianteId = calificacionOptional.get().getEstudiante().getId();
		        Long cursoId = calificacionOptional.get().getCurso().getId();

		        // Eliminar la calificación de la asignatura
		        calificacionRepo.deleteById(id);

		        // Eliminar la calificación final si existe
		        Optional<CalificacionesModel> notaFinalOptional = calFinalRep.findByEstudianteIdAndCursoId(estudianteId, cursoId);
		        if (notaFinalOptional.isPresent()) {
		            CalificacionesModel notaFinal = notaFinalOptional.get();
		            calFinalRep.deleteById(notaFinal.getId());
		        }

		        return ResponseEntity.ok("Calificación y nota final eliminadas exitosamente.");
		    } catch (Exception e) {
		        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
		                .body("Error al eliminar la calificación y la nota final: " + e.getMessage());
		    }}
	@GetMapping("/estudiante/{id}")
	public ResponseEntity<List<CalificacionAsigDTO>> obtenerPorEstudiante(@PathVariable Long id) {
	    try {
	        List<CalificacionAsigDTO> calificaciones = calAsigServ.obtenerCalificacionesPorEstudiante(id);
	        return ResponseEntity.ok(calificaciones);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
	                .body(Collections.emptyList());
	    }
	}



		 //listar asignaturas y cursos
		 @GetMapping("/asignaturas")
		 public List<AsignaturaModel>obtenerAsignatura()
		 {
			 return asignaturaServ.listar();
		 }
		 @GetMapping("/cursos")
		 public List<CursoModel>obtenerCursos()
		 {
			 return cursoServ.listar();
		 }
		 @GetMapping("/estudiantes")
		 public List<EstudianteModel>obtenerEstudiantes()
		 {
			 return estServ.listar();
		 }
}
