package com.escuela.GestionNotas.DTO;

import lombok.Data;
@Data
public class NotaAsignaturaDTO {
    private Long fkAsignatura; // ID de la asignatura
    private Double nota;       // Nota de la asignatura

    public NotaAsignaturaDTO(Long fkAsignatura, Double nota) {
        this.fkAsignatura = fkAsignatura;
        this.nota = nota;
    }
}