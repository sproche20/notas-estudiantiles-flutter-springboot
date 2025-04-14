package com.escuela.GestionNotas.modelo;

import java.io.Serializable;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name="tb_CalifacionAsignatura")
public class CalificacionAsignaturaModel implements Serializable{
	 private static final long serialVersionUID = 1L;

	    @Id
	    @GeneratedValue(strategy = GenerationType.IDENTITY)
	    private Long id;

	    // Un estudiante tiene varias calificaciones (una por cada asignatura)
	    @ManyToOne(fetch = FetchType.LAZY)
	    @JoinColumn(name = "fkEstudiante")
	    @JsonIgnore
	    private EstudianteModel estudiante;

	    // Un curso tiene varias calificaciones asociadas
	    @ManyToOne(fetch = FetchType.LAZY)
	    @JoinColumn(name = "fkCurso")
	    @JsonIgnore
	    private CursoModel curso;
	    // Relación con las asignaturas
	    @OneToMany(mappedBy = "calificacionAsignatura", cascade = CascadeType.ALL, orphanRemoval = true)
	    private List<CalificacionNotaModel> calificacionesNotas;

}
