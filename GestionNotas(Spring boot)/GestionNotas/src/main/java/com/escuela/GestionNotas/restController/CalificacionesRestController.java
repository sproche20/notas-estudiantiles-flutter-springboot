package com.escuela.GestionNotas.restController;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
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
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;

import com.escuela.GestionNotas.DTO.CalificacionesDTO;
import com.escuela.GestionNotas.modelo.AsignaturaModel;
import com.escuela.GestionNotas.modelo.CalificacionAsignaturaModel;
import com.escuela.GestionNotas.modelo.CalificacionesModel;
import com.escuela.GestionNotas.modelo.CursoModel;
import com.escuela.GestionNotas.modelo.EstudianteModel;
import com.escuela.GestionNotas.servicio.CalificacionesServicio;
import com.escuela.GestionNotas.servicio.CursoServicio;
import com.escuela.GestionNotas.servicio.EstudianteServicio;

@RestController
@RequestMapping("gestion-notas/notafinal")
public class CalificacionesRestController {
	@Autowired
	private CursoServicio cursoServ;
	@Autowired
	private EstudianteServicio estServ;
	@Autowired
	private CalificacionesServicio calServ;
	//listar notas finales
	@GetMapping
	public ResponseEntity<Page<CalificacionesDTO>>ObtenerCalificacionFinal
	( @RequestParam(defaultValue  = "0") int page, 
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "id") String sortBy
			)
	{
		Pageable pageable=PageRequest.of(page, size, Sort.by(sortBy));
		Page<CalificacionesModel>calificacionesFinales=calServ.listarPageable(pageable);
		Page<CalificacionesDTO> dtoPage=calificacionesFinales.map(cf->new CalificacionesDTO(
				cf.getId(),
				(cf.getEstudiante()!=null) ? cf.getEstudiante().getId() : 0,
				(cf.getCurso()!=null)? cf.getCurso().getId() : 0,
				cf.getNotaFinal()
				));
		return ResponseEntity.ok(dtoPage);
	}
	//buscar por id
	@GetMapping("/{id}")
	public ResponseEntity<CalificacionesModel> obtenerCalificacionFinalPorId(@PathVariable("id")Long id) {
		CalificacionesModel calificacionFinal=calServ.buscarPorId(id);
		return (calificacionFinal!=null)?ResponseEntity.ok(calificacionFinal):ResponseEntity.notFound().build();
	
	}
}
