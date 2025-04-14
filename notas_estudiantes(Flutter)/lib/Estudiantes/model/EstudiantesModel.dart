class EstudiantesModel {
  int? id;
  String nombresEstudiante;
  String apellidosEstudiante;
  int edadEstudiante;
  String nombresRepresentante;
  int fkCursos;
  String? curso;

  EstudiantesModel(
      {this.id,
      required this.nombresEstudiante,
      required this.apellidosEstudiante,
      required this.edadEstudiante,
      required this.nombresRepresentante,
      required this.fkCursos,
      this.curso});

  factory EstudiantesModel.fromJson(Map<String, dynamic> json) {
    return EstudiantesModel(
      id: json["id"],
      nombresEstudiante: json["nombresEstudiante"],
      apellidosEstudiante: json["apellidosEstudiante"],
      edadEstudiante: json["edadEstudiante"],
      nombresRepresentante: json["nombresRepresentante"],
      fkCursos: int.tryParse(json["fkCursos"].toString()) ?? 0,
      curso: json["curso"] ?? "curso desconocido",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombresEstudiante': nombresEstudiante,
      'apellidosEstudiante': apellidosEstudiante,
      'edadEstudiante': edadEstudiante,
      'nombresRepresentante': nombresRepresentante,
      'fkCursos': fkCursos,
    };
  }
}
