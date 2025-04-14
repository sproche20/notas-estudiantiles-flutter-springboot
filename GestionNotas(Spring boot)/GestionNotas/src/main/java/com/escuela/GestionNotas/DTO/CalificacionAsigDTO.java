package com.escuela.GestionNotas.DTO;

import lombok.Data;
import java.util.List;

@Data
public class CalificacionAsigDTO {
	 private Long id;                // Id de la calificación asignatura
	    private Long fkEstudiante;      // ID del estudiante (relacionado con Estudiante)
	    private Long fkCurso;           // ID del curso (relacionado con Curso)
	    private List<NotaAsignaturaDTO> notas;  // Lista de notas por asignatura

	    public CalificacionAsigDTO(Long id, Long fkEstudiante, Long fkCurso, List<NotaAsignaturaDTO> notas) {
	        this.id = id;
	        this.fkEstudiante = fkEstudiante;
	        this.fkCurso = fkCurso;
	        this.notas = notas;
	    }
}


