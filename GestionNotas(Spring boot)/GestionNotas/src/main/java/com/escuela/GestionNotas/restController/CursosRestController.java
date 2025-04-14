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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.escuela.GestionNotas.DTO.CursosDTO;
import com.escuela.GestionNotas.modelo.AsignaturaModel;
import com.escuela.GestionNotas.modelo.CursoModel;
import com.escuela.GestionNotas.modelo.DocenteModel;
import com.escuela.GestionNotas.modelo.EstudianteModel;
import com.escuela.GestionNotas.repositorio.CursoRepositorio;
import com.escuela.GestionNotas.servicio.CursoServicio;
import com.escuela.GestionNotas.servicio.DocenteServicio;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping("gestion-notas/cursos")
public class CursosRestController {
	@Autowired
	private CursoRepositorio cursoRep;
	@Autowired
	private CursoServicio cursoServ;
	@Autowired
	private DocenteServicio docenteServ;
	//obtener todos los cursos
	
	@GetMapping
	public List<CursosDTO>obtenerCursos()
	{
		List<CursoModel>cursos=cursoServ.listar();
		return cursos.stream().map(c->new CursosDTO(
				c.getId(),
				c.getCurso(),
				(c.getFkDocente()!=null) ? c.getFkDocente().getId():0
				)).collect(Collectors.toList());
	}
	//crear curso
	@PostMapping
	public ResponseEntity<?> crearCurso(@RequestBody Map<String, Object>datos) {
		try {
			CursoModel nuevoCurso=new CursoModel();
			String nombreCurso=datos.get("curso").toString();
			Long docenteId=Long.valueOf(datos.get("fkDocente").toString());
			
			//buscar los objetos relacionados
			DocenteModel docente=docenteServ.buscarPorId(docenteId);
			if (docente==null) {
				return ResponseEntity.badRequest().body("Docente no encontrado");
			}
			if (cursoRep.existsByFkDocenteId(docenteId)) {
	            return ResponseEntity.badRequest().body("El docente ya está asignado a un curso."); 
			}
			nuevoCurso.setCurso(nombreCurso);
			nuevoCurso.setFkDocente(docente);
			cursoServ.insertar(nuevoCurso);
			return ResponseEntity.ok(nuevoCurso);
		} catch (Exception e) {
			// TODO: handle exception
	         return ResponseEntity.badRequest().body("Error al guardar el curso: " + e.getMessage());

		}
	}
	@GetMapping("/{id}")
	public ResponseEntity<CursoModel> obtenerCursoPorId(@PathVariable("id")Long id) {
		CursoModel cursos=cursoServ.buscarPorId(id);
		return (cursos!=null)?ResponseEntity.ok(cursos):ResponseEntity.notFound().build();
	}
//actualizar
	@PutMapping("/{id}")
	public ResponseEntity<?>actualizarCurso(@PathVariable("id")Long id, @RequestBody Map<String, Object>datos)
	{
		try {
			CursoModel cursoExistente=cursoServ.buscarPorId(id);
			if (cursoExistente==null) {
				return ResponseEntity.notFound().build();
			}
			CursoModel nuevoCurso=new CursoModel();
			String nombreCurso=datos.get("curso").toString();
			Long docenteId=Long.valueOf(datos.get("fkDocente").toString());
			//buscar los objetos relacionados
			DocenteModel docente=docenteServ.buscarPorId(docenteId);
			if (docente==null) {
				return ResponseEntity.badRequest().body("Docente no encontrado");
			}
			if (!cursoExistente.getFkDocente().getId().equals(docenteId)) {
			    if (cursoRep.existsByFkDocenteId(docenteId)) {
			        return ResponseEntity.badRequest().body("El docente ya está asignado a otro curso.");
			    }
			}
			cursoExistente.setCurso(nombreCurso);
			cursoExistente.setFkDocente(docente);
			cursoServ.insertar(cursoExistente);
			return ResponseEntity.ok(cursoExistente);

		} catch (Exception e) {
			// TODO: handle exception
	        return ResponseEntity.badRequest().body("Error al actualizar el curso: " + e.getMessage());

		}
	}
	//eliminar
	@DeleteMapping("/{id}")
	public ResponseEntity<?> eliminarCurso(@PathVariable("id") Long id) {
	    Optional<CursoModel> cursOpt = cursoRep.findById(id);
	    if (cursOpt.isEmpty()) {
	        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Curso no encontrado");
	    }

	    CursoModel curso = cursOpt.get();

	    // Validar si hay estudiantes activos
	    boolean tieneEstudiantesActivos = curso.getListarEstudiantes()
	        .stream()
	        .anyMatch(EstudianteModel::isActivo);  // Verifica si hay estudiantes activos

	    if (tieneEstudiantesActivos) {
	        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
	            .body("El curso tiene estudiantes activos. Desactívelos primero.");
	    }

	    try {
	        cursoRep.delete(curso); // Elimina el curso y las calificaciones por cascada
	        return ResponseEntity.ok("Curso eliminado con éxito");
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
	            .body("Error al eliminar el curso");
	    }
	}

}
