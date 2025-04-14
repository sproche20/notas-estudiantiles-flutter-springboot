package com.escuela.GestionNotas.restController;

import java.util.List;
import java.util.Optional;

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

import com.escuela.GestionNotas.modelo.AsignaturaModel;
import com.escuela.GestionNotas.modelo.DocenteModel;
import com.escuela.GestionNotas.repositorio.AsignaturaRepositorio;
import com.escuela.GestionNotas.servicio.AsignaturaServicio;

@RestController
@RequestMapping("gestion-notas/asignaturas")
public class AsignaturaRestController {
	@Autowired
	private AsignaturaRepositorio asigRep;
	@Autowired
	private AsignaturaServicio asigSer;
	//listar Asignaturas
	@GetMapping
	public List<AsignaturaModel>obtenerAsignaturas()
	{
		return asigSer.listar();
	}
	//crear asignaturas
	@PostMapping
	public ResponseEntity<AsignaturaModel> crearAsignatura(@RequestBody AsignaturaModel nuevaAsignatura) {
	    asigSer.insertar(nuevaAsignatura);
	    return ResponseEntity.status(HttpStatus.ACCEPTED.CREATED).body(nuevaAsignatura);
	}

	//buscar por id
	@GetMapping("/{id}")
	public ResponseEntity<AsignaturaModel> obtenerAsignaturaPorId(@PathVariable("id")Long id) {
		AsignaturaModel asignaturas=asigSer.buscarPorId(id);
		return (asignaturas!=null)?ResponseEntity.ok(asignaturas):ResponseEntity.notFound().build();
	
	}
	//actualizar Asignatura
	@PutMapping("/{id}")
	public ResponseEntity<AsignaturaModel>actualizarAsignatura(@PathVariable ("id")Long id, @RequestBody AsignaturaModel asgnaturaActualizada) 
	{
		AsignaturaModel asignaturaExistente=asigSer.buscarPorId(id);
		if (asignaturaExistente==null) {
			return ResponseEntity.notFound().build();
		}
		asgnaturaActualizada.setId(id);
		asigSer.insertar(asgnaturaActualizada);
		return ResponseEntity.ok(asgnaturaActualizada);
	}
	//eliminar Asignatura
	@DeleteMapping("/{id}")
	public ResponseEntity<?>eliminarAsignatura(@PathVariable("id")Long id)
	{
		Optional< AsignaturaModel>asigOpt=asigRep.findById(id);
		if (asigOpt.isEmpty()) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body("asignatura no encontrada");
		}
		AsignaturaModel asignatura=asigOpt.get();
		if (!asignatura.getDocentes().isEmpty()) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(" No se puede eliminar, la Asignatura tiene Docentes asignado.");
		}try {
			asigRep.delete(asignatura);
			return ResponseEntity.status(HttpStatus.OK).body("Asignatura  Eliminada con exito");
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error al eliminar la asignatura");
		}
	}
}
