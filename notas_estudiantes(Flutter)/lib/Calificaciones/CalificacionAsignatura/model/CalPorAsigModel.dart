import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class CalPorAsigModel {
  int? id;
  int fkEstudiante;
  int fkCurso;
  List<NotaAsignatura> notas; // Lista de notas, en lugar de una sola nota
  String? nombreEstudiante;
  String? nombreAsignatura;
  String? Curso;

  CalPorAsigModel({
    this.id,
    required this.fkEstudiante,
    required this.fkCurso,
    required this.notas,
    this.nombreEstudiante,
    this.nombreAsignatura,
    this.Curso,
  });

  factory CalPorAsigModel.fromJson(Map<String, dynamic> json) {
    var listNotas = json['notas'] as List; // Usa 'notas' en lugar de 'content'
    List<NotaAsignatura> notasList =
        listNotas.map((i) => NotaAsignatura.fromJson(i)).toList();

    return CalPorAsigModel(
      id: json["id"],
      fkEstudiante: int.tryParse(json['fkEstudiante'].toString()) ?? 0,
      fkCurso: int.tryParse(json['fkCurso'].toString()) ?? 0,
      notas: notasList,
      nombreEstudiante: json["nombreEstudiante"] ?? 'Estudiante no encontrado',
      nombreAsignatura: json["nombreAsignatura"] ?? 'Asignatura no encontrada',
      Curso: json["curso"] ?? 'Curso no encontrado',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fkEstudiante': fkEstudiante,
      'fkCurso': fkCurso,
      'notas': notas.map((nota) => nota.toJson()).toList(),
    };
  }
}
