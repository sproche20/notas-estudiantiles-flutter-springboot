class Asignaturamodel {
  int? id;
  String nombreAsignatura;
  Asignaturamodel({this.id, required this.nombreAsignatura});
  factory Asignaturamodel.fromJson(Map<String, dynamic> json) {
    return Asignaturamodel(
        id: json['id'], nombreAsignatura: json["nombreAsignatura"]);
  }
  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, 'nombreAsignatura': nombreAsignatura};
  }
}
