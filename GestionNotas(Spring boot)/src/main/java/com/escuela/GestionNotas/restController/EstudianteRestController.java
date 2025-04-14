package com.escuela.GestionNotas.restController;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.escuela.GestionNotas.DTO.EstudiantesDTO;
import com.escuela.GestionNotas.modelo.AsignaturaModel;
import com.escuela.GestionNotas.modelo.CalificacionesModel;
import com.escuela.GestionNotas.modelo.CursoModel;
import com.escuela.GestionNotas.modelo.DocenteModel;
import com.escuela.GestionNotas.modelo.EstudianteModel;
import com.escuela.GestionNotas.repositorio.EstudianteRepositorio;
import com.escuela.GestionNotas.servicio.CalificacionesServicio;
import com.escuela.GestionNotas.servicio.CursoServicio;
import com.escuela.GestionNotas.servicio.EstudianteServicio;

@RestController
@RequestMapping("gestion-notas/estudiantes")
public class EstudianteRestController {
	@Autowired 
	private EstudianteServicio EstServ;
	@Autowired
	private CursoServicio CursoServ;
	@Autowired
	private EstudianteRepositorio estRep;

	//listar estudiantes
	
	@GetMapping
	public List<EstudiantesDTO>obtenerEstudiantes()
	{
		List<EstudianteModel>estudiantes=EstServ.listar();
		return estudiantes.stream().map(e->new EstudiantesDTO(
				e.getId(),
				e.getNombresEstudiante(),
				e.getApellidosEstudiante(),
				e.getEdadEstudiante(),
				e.getNombresRepresentante(),
				(e.getFkCursos()!=null) ? e.getFkCursos().getId():0
				)).collect(Collectors.toList());
	}
	//crear nuevo estudiante
	@PostMapping
	public ResponseEntity<?>guardarEstudiante(@RequestBody Map<String, Object>datos)
	{
		try {
			//extraer los datos del json
			EstudianteModel nuevoEstudiante=new EstudianteModel();
			String nombresEstudiante=datos.get("nombresEstudiante").toString();
			String ApellidosEstudiante=datos.get("apellidosEstudiante").toString();
			Long EdadEstudiante=Long.valueOf(datos.get("edadEstudiante").toString());
			String nombresRepresentante=datos.get("nombresRepresentante").toString();
			Long fkCursos=Long.valueOf(datos.get("fkCursos").toString());
			
			//buscar los objetos relacionados
			CursoModel curso=CursoServ.buscarPorId(fkCursos);

			if (curso==null) {
	             return ResponseEntity.badRequest().body(" cursos no encontrados");
			}
			//asignar valores al objeto estudiante
			nuevoEstudiante.setNombresEstudiante(nombresEstudiante);
			nuevoEstudiante.setApellidosEstudiante(ApellidosEstudiante);
			nuevoEstudiante.setEdadEstudiante(EdadEstudiante);
			nuevoEstudiante.setNombresRepresentante(nombresRepresentante);
			nuevoEstudiante.setFkCursos(curso);
			
			EstServ.insertar(nuevoEstudiante);
			return ResponseEntity.ok(nuevoEstudiante);
			
		} catch (Exception e) {
			// TODO: handle exception
	         return ResponseEntity.badRequest().body("Error al guardar el Estudiante: " + e.getMessage());
		}
		
	}
	
	@GetMapping("/{id}")
	public ResponseEntity<EstudianteModel> obtenerEstudiantePorId(@PathVariable("id")Long id) {
		EstudianteModel estudiantes=EstServ.buscarPorId(id);
		return (estudiantes!=null)?ResponseEntity.ok(estudiantes):ResponseEntity.notFound().build();
	
	}
	
	//actualizar Estudiante
	 @PutMapping("/{id}")
	 public ResponseEntity<?>actualizarEstudiante(@PathVariable("id")Long id,@RequestBody Map<String, Object>datos)
	 {
		 try {
			EstudianteModel estudianteExistente=EstServ.buscarPorId(id);
			if (estudianteExistente==null) {
				return ResponseEntity.notFound().build();
			}
			//extraer los datos del json
			EstudianteModel nuevoEstudiante=new EstudianteModel();
			String nombresEstudiante=datos.get("nombresEstudiante").toString();
			String ApellidosEstudiante=datos.get("apellidosEstudiante").toString();
			Long EdadEstudiante=Long.valueOf(datos.get("edadEstudiante").toString());
			String NombresRepresante=datos.get("nombresRepresentante").toString();
			Long fkCursos=Long.valueOf(datos.get("fkCursos").toString());
			
			//buscar los objetos relacionados
			CursoModel curso=CursoServ.buscarPorId(fkCursos);

			if (curso==null) {
	             return ResponseEntity.badRequest().body("  cursos no encontrados");
			}
			//asignar valores al objeto estudiante
			estudianteExistente.setNombresEstudiante(nombresEstudiante);
			estudianteExistente.setApellidosEstudiante(ApellidosEstudiante);
			estudianteExistente.setEdadEstudiante(EdadEstudiante);
			estudianteExistente.setNombresRepresentante(NombresRepresante);
			estudianteExistente.setFkCursos(curso);

			EstServ.insertar(estudianteExistente);
			return ResponseEntity.ok(estudianteExistente);
			
		} catch (Exception e) {
			// TODO: handle exception
	        return ResponseEntity.badRequest().body("Error al actualizar al estudiante: " + e.getMessage());

		}
	 }
	 //eliminar Estudiantes
	 @DeleteMapping("/{id}")
	 public ResponseEntity<Void> eliminarEstudiante(@PathVariable("id") Long id) {
	     EstudianteModel estudiante = estRep.findById(id).orElse(null);
	     if (estudiante == null) {
	         return ResponseEntity.notFound().build(); // Si no se encuentra el estudiante, respondemos con 404
	     }
	     estudiante.setActivo(false);
	     estRep.save(estudiante);
	     return ResponseEntity.noContent().build(); // Si todo está bien, respondemos con 204 No Content
	 }

	 @GetMapping("/cursos")
	 public List<CursoModel>obtenerCursos()
	 {
		 return CursoServ.listar();
	 }
	 @GetMapping("/cursos/{id}")
	 public List<EstudianteModel> obtenerPorCurso(@PathVariable Long id) {
	     return EstServ.buscarPorCursoId(id);
	 }

}
