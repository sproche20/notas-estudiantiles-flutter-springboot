import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Calfinalmodel {
  int? id;
  int fkEstudiante;
  int fkCurso;
  String? nombreEstudiante;
  String? apellidoEstudiante;
  double notaFinal; // <-- Usar 'double' en lugar de 'Double'
  List<NotaAsignatura>? notasPorAsignatura;

  Calfinalmodel(
      {this.id,
      required this.fkEstudiante,
      required this.fkCurso,
      required this.notaFinal,
      this.nombreEstudiante,
      this.apellidoEstudiante,
      this.notasPorAsignatura});

  factory Calfinalmodel.fromJson(Map<String, dynamic> json) {
    return Calfinalmodel(
        id: json["id"],
        fkEstudiante: int.tryParse(json['fkEstudiante'].toString()) ?? 0,
        fkCurso: int.tryParse(json['fkCurso'].toString()) ?? 0,
        notaFinal: json['notaFinal'] is double
            ? json['notaFinal']
            : double.tryParse(json['notaFinal'].toString()) ??
                0.0, // <-- Convierte correctamente a double
        nombreEstudiante: json["nombreEstudiante"],
        apellidoEstudiante: json["apellidoEstudiante"]);
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'fkCurso': fkCurso,
      'fkEstudiante': fkEstudiante,
      'nota': notaFinal, // <-- Ya está en double, no necesita conversión
    };
  }
}
