package com.escuela.GestionNotas.DTO;

import lombok.Data;

@Data
public class CalificacionesDTO {
    private Long id;
    private Long fkEstudiante;
    private Long fkCurso;
    private double notaFinal;

    // Constructor con parámetros
    public CalificacionesDTO(Long id, Long fkEstudiante, Long fkCurso, double notaFinal) {
        this.id = id;
        this.fkEstudiante = fkEstudiante;
        this.fkCurso = fkCurso;
        this.notaFinal = notaFinal;
    }
}

