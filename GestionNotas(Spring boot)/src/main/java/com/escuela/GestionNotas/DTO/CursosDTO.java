package com.escuela.GestionNotas.DTO;

import lombok.Data;

@Data
public class CursosDTO {
	private Long id;
	private String curso;
	private Long fkDocente;
	public  CursosDTO(Long id,String curso,Long fkDocente) 
	{
		this.id=id;
		this.curso=curso;
		this.fkDocente=fkDocente;
	}
}
