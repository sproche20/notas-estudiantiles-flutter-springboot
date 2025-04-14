package com.escuela.GestionNotas.modelo;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonBackReference;

import jakarta.persistence.Column;
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
@Table(name="tb_Estudiante")
public class EstudianteModel implements Serializable{
	private static final long serialVersionUID=1L;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	private String nombresEstudiante;
	private String apellidosEstudiante;
	private Long edadEstudiante;
	private String nombresRepresentante;
	//varios estudiantes estan en un curso
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "fkCursos")
    @JsonBackReference
	private CursoModel fkCursos;
	@Column(name = "activo")
	private boolean activo = true;
}
