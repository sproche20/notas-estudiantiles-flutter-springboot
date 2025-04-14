class NotaAsignatura {
  int fkAsignatura;
  double nota;
  String? nombreAsignatura; // Agregar nombre de la asignatura

  NotaAsignatura({
    required this.fkAsignatura,
    required this.nota,
    this.nombreAsignatura, // Agregar al constructor
  });

  factory NotaAsignatura.fromJson(Map<String, dynamic> json) {
    print("Datos del JSON de NotaAsignatura: $json");

    return NotaAsignatura(
      fkAsignatura: int.tryParse(json["fkAsignatura"].toString()) ?? 0,
      nota: double.tryParse(json['nota'].toString()) ?? 0,
      nombreAsignatura: json["nombreAsignatura"] ?? "Asignatura desconocida",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fkAsignatura': fkAsignatura,
      'nota': nota,
    };
  }
}
