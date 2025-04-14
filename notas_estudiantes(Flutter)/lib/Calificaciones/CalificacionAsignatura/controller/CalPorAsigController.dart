import 'package:notas_estudiantes/enlaces/Enlaces.dart';
import 'package:http/http.dart' as http;

class Calporasigcontroller {
  final String baseUrl = Enlacesurl.calAsigUrl;
  final String AsignaturaUrl = Enlacesurl.asignaturaUrl;
  final String EstudianteUrl = Enlacesurl.estudianteUrl;
  final String CursosUrl = Enlacesurl.cursosUrl;
  //listar
  Future<List<CalPorAsigModel>> obtenerCalificacionesAsignatura() async {
    final response = await http.get(Uri.parse(baseUrl));
    print(
        "Respuesta Api asignaciones(${response.statusCode}):${response.body}");

    if (response.statusCode == 200) {
      // Decodificamos el JSON
      Map<String, dynamic> jsonData = json.decode(response.body);

      // Accedemos directamente a 'content' como una lista
      List<dynamic> content = jsonData['content'];

      // Mapeamos cada objeto dentro de 'content' al modelo CalPorAsigModel
      List<CalPorAsigModel> calificaciones =
          content.map((json) => CalPorAsigModel.fromJson(json)).toList();

      // Usamos Future.wait para hacer múltiples peticiones a la vez
      for (var calificacion in calificaciones) {
        var futureEstudiante =
            obtenerNombreEstudiantes(calificacion.fkEstudiante);
        var futureCurso = obtenerNombreCurso(calificacion.fkCurso);

        var futureNotas = calificacion.notas
            .where((n) => n.fkAsignatura != null)
            .map((nota) async {
          nota.nombreAsignatura =
              await obtenerNombreAsignaturas(nota.fkAsignatura!);
        });

        // Esperamos a que todas las peticiones asíncronas terminen
        await Future.wait([
          futureEstudiante,
          futureCurso,
          ...futureNotas,
        ]);

        calificacion.nombreEstudiante = await futureEstudiante;
        calificacion.Curso = await futureCurso;
      }

      return calificaciones;
    } else {
      throw Exception("Error al obtener las asignaciones");
    }
  }

  Future<bool> ingresarCalificacion(CalPorAsigModel calificacion) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(calificacion.toJson()),
    );
    print("Código de estado: ${response.statusCode}");
    print("Respuesta del servidor: ${response.body}");
    return response.statusCode == 200 || response.statusCode == 201;
  }

  //actualizar calificaciones
  Future<bool> actualizarCalificaciones(
      int id, CalPorAsigModel calificacion) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(calificacion
            .toJson()), // Asegúrate de que `toJson()` esté bien implementado
      );
      if (response.statusCode == 200) {
        return true; // La actualización fue exitosa
      } else {
        print("Error en la respuesta del servidor: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error al actualizar las calificaciones: $e");
      return false;
    }
  }

  //eliminar calificaciones
  Future<bool> eliminarCalificaciones(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    return response.statusCode == 204;
  }

  //listarCursos
  Future<List<Cursosmodel>> obtenerCursos() async {
    final response = await http.get(Uri.parse(CursosUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Cursosmodel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener la lista de cursos');
    }
  }

  //obtener nombre del curso
  Future<String> obtenerNombreCurso(int CursoId) async {
    try {
      final response = await http.get(Uri.parse("$CursosUrl/$CursoId"));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data["curso"] ?? "Curso no encontrado";
      } else {
        return "Curso no encontrado";
      }
    } catch (e) {
      return "Error al obtener Curso";
    }
  }

  //listar asignaturas
  Future<List<Asignaturamodel>> obtenerasignaturas() async {
    final response = await http.get(Uri.parse(AsignaturaUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Asignaturamodel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener la lista de asignaturas');
    }
  }

  //obtener nombre de la asignatura
  Future<String> obtenerNombreAsignaturas(int id) async {
    try {
      final response = await http.get(Uri.parse('$AsignaturaUrl/$id'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['nombreAsignatura'] ?? 'Sin nombre';
      } else {
        return 'Asignatura no encontrada';
      }
    } catch (e) {
      return 'Error';
    }
  }

  //listarEstudiantes
  Future<List<EstudiantesModel>> obtenerEstudiantes() async {
    final response = await http.get(Uri.parse(EstudianteUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => EstudiantesModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener la lista de estudiantes');
    }
  }

  //obtener nombre de los estudiantes
  Future<String> obtenerNombreEstudiantes(int estudiantesId) async {
    try {
      final response =
          await http.get(Uri.parse("$EstudianteUrl/$estudiantesId"));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data["nombresEstudiante"] ?? "estudiante no encontrado";
      } else {
        return "estudiante no encontrado";
      }
    } catch (e) {
      return "Error al obtener estudiante";
    }
  }

  Future<List<EstudiantesModel>> obtenerEstudiantesPorCurso(int id) async {
    final response = await http.get(Uri.parse('$EstudianteUrl/cursos/$id'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => EstudiantesModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar el estudiante de curso');
    }
  }

  // Método para obtener las calificaciones de un estudiante por su ID
  Future<List<CalPorAsigModel>> obtenerCalificacionesPorEstudiante(
      int estudianteId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/estudiante/$estudianteId'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<CalPorAsigModel> calificaciones =
          jsonData.map((json) => CalPorAsigModel.fromJson(json)).toList();

      for (var calificacion in calificaciones) {
        calificacion.nombreEstudiante =
            await obtenerNombreEstudiantes(calificacion.fkEstudiante);
        for (var nota in calificacion.notas) {
          nota.nombreAsignatura =
              await obtenerNombreAsignaturas(nota.fkAsignatura);
        }
        calificacion.Curso = await obtenerNombreCurso(calificacion.fkCurso);
      }

      return calificaciones;
    } else {
      throw Exception("Error al obtener las calificaciones del estudiante");
    }
  }

  Future<List<CalPorAsigModel>> obtenerNotasPorAsignatura(
      int asignaturaId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/asignatura/$asignaturaId'));
    print(
        "Respuesta Api notas por asignatura (${response.statusCode}): ${response.body}");

    if (response.statusCode == 200) {
      // Decodificamos el JSON
      List<dynamic> jsonData = json.decode(response.body);

      // Mapeamos cada objeto dentro de la respuesta a CalPorAsigModel
      List<CalPorAsigModel> calificaciones =
          jsonData.map((json) => CalPorAsigModel.fromJson(json)).toList();

      // Asignamos el nombre de los estudiantes y la asignatura a cada calificación
      for (var calificacion in calificaciones) {
        calificacion.nombreEstudiante =
            await obtenerNombreEstudiantes(calificacion.fkEstudiante);

        // Asignación del nombre de la asignatura a cada nota
        for (var nota in calificacion.notas) {
          nota.nombreAsignatura =
              await obtenerNombreAsignaturas(nota.fkAsignatura);
        }

        calificacion.Curso = await obtenerNombreCurso(calificacion.fkCurso);
      }

      return calificaciones;
    } else {
      throw Exception("Error al obtener las calificaciones por asignatura");
    }
  }
}
