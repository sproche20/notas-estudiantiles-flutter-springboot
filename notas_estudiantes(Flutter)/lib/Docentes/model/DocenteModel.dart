class Docentemodel {
  int? id;
  String nombresDocente;
  String apellidosDocente;
  String especialidadDocente;
  int fkAsignatura;
  String? nombreAsignatura;
  Docentemodel(
      {this.id,
      required this.nombresDocente,
      required this.apellidosDocente,
      required this.especialidadDocente,
      required this.fkAsignatura,
      this.nombreAsignatura});
  factory Docentemodel.fromJson(Map<String, dynamic> json) {
    return Docentemodel(
        id: json["id"],
        nombresDocente: json["nombresDocente"],
        apellidosDocente: json["apellidosDocente"],
        especialidadDocente: json["especialidadDocente"],
        fkAsignatura: int.tryParse(json["fkAsignatura"].toString()) ?? 0,
        nombreAsignatura: json["nombreAsignatura"] ?? "asignatura desconocida");
  }
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombresDocente': nombresDocente,
      'apellidosDocente': apellidosDocente,
      'especialidadDocente': especialidadDocente,
      'fkAsignatura': fkAsignatura,
    };
  }
}
