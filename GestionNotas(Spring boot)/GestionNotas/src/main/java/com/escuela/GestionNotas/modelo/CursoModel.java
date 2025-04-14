package com.escuela.GestionNotas.modelo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name="tb_Cursos")
public class CursoModel implements Serializable{
	private static final long serialVersionUID=1L;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	private String curso;
	//un curso tiene un solo Tutor de curso que puede ser cualquier docente asignado
	@OneToOne
	@JoinColumn(name = "fkDocente")
    @JsonIgnore
	private DocenteModel fkDocente;
	//un curso tiene varios estudiantes
	@OneToMany(mappedBy = "fkCursos",cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference
	private List<EstudianteModel>listarEstudiantes=new ArrayList<>();
	// En CursoModel
	@OneToMany(mappedBy = "curso", cascade = CascadeType.ALL, orphanRemoval = true)
	@JsonIgnore
	private List<CalificacionAsignaturaModel> listaCalificaciones=new ArrayList<>();
}
