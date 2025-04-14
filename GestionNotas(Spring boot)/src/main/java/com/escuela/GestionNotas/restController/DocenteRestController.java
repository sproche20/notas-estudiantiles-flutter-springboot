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

import com.escuela.GestionNotas.DTO.DocentesDTO;
import com.escuela.GestionNotas.modelo.AsignaturaModel;
import com.escuela.GestionNotas.modelo.CursoModel;
import com.escuela.GestionNotas.modelo.DocenteModel;
import com.escuela.GestionNotas.repositorio.DocenteRepositorio;
import com.escuela.GestionNotas.servicio.AsignaturaServicio;
import com.escuela.GestionNotas.servicio.CursoServicio;
import com.escuela.GestionNotas.servicio.DocenteServicio;



@RestController
@RequestMapping("gestion-notas/docentes")
public class DocenteRestController {
	@Autowired
	private DocenteRepositorio docentesRep;
	@Autowired
	private DocenteServicio docenteServ;
	@Autowired
	private AsignaturaServicio asignaturaServ;
	@Autowired
	private CursoServicio cursoServ;
	//Listar Docentes
	@GetMapping
	public List<DocentesDTO> obtenerDocentes() {
	    List<DocenteModel> docentes = docenteServ.listar();
	    return docentes.stream().map(d -> new DocentesDTO(
	            d.getId(),
	            d.getNombresDocente(),
	            d.getApellidosDocente(),
	            d.getEspecialidadDocente(),
	            (d.getFkAsignatura() != null) ? d.getFkAsignatura().getId() : 0 // Se eliminó la coma extra
	    )).collect(Collectors.toList());
	}

	//crear nuevo docente
	@PostMapping
	public ResponseEntity<?>guardarDocente(@RequestBody Map<String, Object>datos)
	{
		try {
			//extraer datos del json
			DocenteModel nuevoDocente=new DocenteModel();
			String NombresDocente=datos.get("nombresDocente").toString();
			String ApellidosDocente=datos.get("apellidosDocente").toString();
			String EspecialidadDocente=datos.get("especialidadDocente").toString();
			Long asignaturaId=Long.valueOf(datos.get("fkAsignatura").toString());
			
			//buscar los objetos relacionados
			AsignaturaModel asignatura=asignaturaServ.buscarPorId(asignaturaId);
			if (asignatura==null) {
	             return ResponseEntity.badRequest().body("Asignatura no encontrada");
			}
			//asignar valores al objecto docente
			nuevoDocente.setNombresDocente(NombresDocente);
			nuevoDocente.setApellidosDocente(ApellidosDocente);
			nuevoDocente.setEspecialidadDocente(EspecialidadDocente);
			nuevoDocente.setFkAsignatura(asignatura);
			//guardar en la base de datos
			docenteServ.insertar(nuevoDocente);
			return ResponseEntity.ok(nuevoDocente);
			
		} catch (Exception e) {
			// TODO: handle exception
	         return ResponseEntity.badRequest().body("Error al guardar el docente: " + e.getMessage());

		}
	}
	@GetMapping("/{id}")
	public ResponseEntity<DocenteModel> obtenerDocentePorId(@PathVariable("id")Long id) {
		DocenteModel docentes=docenteServ.buscarPorId(id);
		return (docentes!=null)?ResponseEntity.ok(docentes):ResponseEntity.notFound().build();
	
	}

	//actualizar Docente
	 @PutMapping("/{id}")
	 public ResponseEntity<?>actualizarDocente(@PathVariable("id")Long id,@RequestBody Map<String, Object>datos)
	 {
		 try {
			 DocenteModel docenteExistente=docenteServ.buscarPorId(id);
			 if (docenteExistente==null) {
				 return ResponseEntity.notFound().build();
			}
			 //extraer los datos del json
			 DocenteModel nuevoDocente=new DocenteModel();
				String NombresDocente=datos.get("nombresDocente").toString();
				String ApellidosDocente=datos.get("apellidosDocente").toString();
				String EspecialidadDocente=datos.get("especialidadDocente").toString();
				Long asignaturaId=Long.valueOf(datos.get("fkAsignatura").toString());
				//buscar los objetos relacionados
				AsignaturaModel asignatura=asignaturaServ.buscarPorId(asignaturaId);
				if (asignatura==null) {
		             return ResponseEntity.badRequest().body("Asignatura no encontrada");
				}
				//actualizar los valores
				//asignar valores al objecto docente
				docenteExistente.setNombresDocente(NombresDocente);
				docenteExistente.setApellidosDocente(ApellidosDocente);
				docenteExistente.setEspecialidadDocente(EspecialidadDocente);
				docenteExistente.setFkAsignatura(asignatura);
				docenteServ.insertar(docenteExistente);
				return ResponseEntity.ok(docenteExistente);
		} catch (Exception e) {
			// TODO: handle exception
	        return ResponseEntity.badRequest().body("Error al actualizar el docente: " + e.getMessage());

		}
	 }
	 //eliminar Docentes
	 @DeleteMapping("/{id}")
	 public ResponseEntity<?>eliminarDocente(@PathVariable("id")Long id)
	 {
		 	Optional<DocenteModel>docenteOpt=docentesRep.findById(id);
		 	if (docenteOpt.isEmpty()) {
		 		return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Docente no encontrado.");
		 	}
		 	DocenteModel docente=docenteOpt.get();
		 	//verificar si hay docentes en otras asignaturas
		 	if (!docente.getTutorCurso().isEmpty()) {
		        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("El Docente es tutor de un curso.");
			}
		 	try {
				docentesRep.delete(docente);
		        return ResponseEntity.status(HttpStatus.OK).body("Docente eliminado con éxito.");
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
		        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error al eliminar al docente.");

			}
	 }
	 //listar asignaturas y cursos
	 @GetMapping("/asignaturas")
	 public List<AsignaturaModel>obtenerAsignatura()
	 {
		 return asignaturaServ.listar();
	 }
}
