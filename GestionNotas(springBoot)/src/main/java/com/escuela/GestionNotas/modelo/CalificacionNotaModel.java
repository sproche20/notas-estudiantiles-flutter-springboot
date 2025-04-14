package com.escuela.GestionNotas.modelo;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "tb_CalificacionNota")
public class CalificacionNotaModel implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Relación con la calificación asignatura (sin duplicar Estudiante, Curso, Asignatura)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fkCalificacionAsignatura")
    @JsonIgnore
    private CalificacionAsignaturaModel calificacionAsignatura;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fkAsignatura")
    private AsignaturaModel asignatura;

    // Nota específica de esta asignatura
    private Double nota;
}
