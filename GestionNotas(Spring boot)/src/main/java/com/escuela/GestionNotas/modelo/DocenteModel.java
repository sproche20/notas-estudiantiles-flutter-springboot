package com.escuela.GestionNotas.modelo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
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
@Table(name="tb_Docente")
public class DocenteModel implements Serializable{
	private static final long serialVersionUID=1L;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	private String nombresDocente;
	private String apellidosDocente;
	private String especialidadDocente;
	// un docente solo puede ser asignado a un asignatura 
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="fkAsignatura")
    @JsonBackReference
	private AsignaturaModel fkAsignatura;
	@OneToMany(mappedBy = "fkDocente")
	@JsonManagedReference
	private List<CursoModel>tutorCurso=new ArrayList<>();

}
