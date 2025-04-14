package com.escuela.GestionNotas.DTO;


import lombok.Data;

@Data
public class DocentesDTO {
	private Long id;
	private String nombresDocente;
	private String apellidosDocente;
	private String especialidadDocente;
	private Long fkAsignatura;
	
	public DocentesDTO(
			Long id,
			String nombresDocente,
			String apellidosDocente,
			String especialidadDocente,
			Long fkAsignatura
			) 
	{
		this.id=id;
		this.nombresDocente=nombresDocente;
		this.apellidosDocente=apellidosDocente;
		this.especialidadDocente=especialidadDocente;
		this.fkAsignatura=fkAsignatura;
		
	}
}
