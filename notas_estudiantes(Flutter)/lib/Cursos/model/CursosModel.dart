class Cursosmodel {
  int? id;
  String curso;
  int fkDocente;
  String? nombreDocente;
  String? apellidoDocente;
  Cursosmodel(
      {this.id,
      required this.curso,
      required this.fkDocente,
      this.nombreDocente,
      this.apellidoDocente});
  factory Cursosmodel.fromJson(Map<String, dynamic> json) {
    return Cursosmodel(
        id: json["id"],
        curso: json["curso"],
        fkDocente: int.tryParse(json["fkDocente"].toString()) ?? 0,
        nombreDocente: json["nombreDocente"],
        apellidoDocente: json["apellidoDocente"]);
  }
  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, 'curso': curso, 'fkDocente': fkDocente};
  }
}
