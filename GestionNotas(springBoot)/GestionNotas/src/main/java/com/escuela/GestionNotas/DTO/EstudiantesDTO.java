package com.escuela.GestionNotas.DTO;

import lombok.Data;

@Data
public class EstudiantesDTO {
	private Long id;
	private String nombresEstudiante;
	private String apellidosEstudiante;
	private Long edadEstudiante;
	private String nombresRepresentante;
	private Long fkCursos;
	public EstudiantesDTO
	(Long id,
	String nombresEstudiante,
	String apellidosEstudiante,
	Long edadEstudiante,
	String nombresRepresentante,
	Long fkCursos
) 
	{
		this.id=id;
		this.nombresEstudiante=nombresEstudiante;
		this.apellidosEstudiante=apellidosEstudiante;
		this.edadEstudiante=edadEstudiante;
		this.nombresRepresentante=nombresRepresentante;
		this.fkCursos=fkCursos;

	}
}
