package com.escuela.GestionNotas.modelo;

import java.io.Serializable;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonManagedReference;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name="tb_CalificacionFinal")
public class CalificacionesModel implements Serializable{
	private static final long serialVersionUID=1L;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	//un estudiante tiene una unica nota final en el curso
	 @OneToOne
	    @JoinColumn(name = "fkEstudiante")
	    @JsonManagedReference
	    private EstudianteModel estudiante;
	 //Un curso tiene varias calificaciones finales(una por estudiante)
	 @ManyToOne
	    @JoinColumn(name="fkCurso")
	    private CursoModel curso;
	// Nota final calculada (promedio de `CalificacionAsignaturaModel`)
	 private double notaFinal;
}
