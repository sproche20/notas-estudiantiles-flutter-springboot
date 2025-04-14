import 'package:notas_estudiantes/enlaces/Enlaces.dart';
import 'package:http/http.dart' as http;

class Calfinalcontroller {
  final String baseUrl = Enlacesurl.calFinalUrl;
  final String EstudianteUrl = Enlacesurl.estudianteUrl;
  final String cursoUrl = Enlacesurl.cursosUrl;
  final String calPorAsigUrl = Enlacesurl.calAsigUrl;

  // Obtener todas las calificaciones finales
  Future<List<Calfinalmodel>> obtenerCalificaciones() async {
    final response = await http.get(Uri.parse(baseUrl));
    print("Respuesta Api notas(${response.statusCode}):${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      // Obtenemos directamente la lista de la clave 'content', que es un array de objetos.
      final List<dynamic> contentList = jsonData['content'];

      // Ahora mapeamos cada objeto de la lista 'content' a un modelo 'Calfinalmodel'.
      List<Calfinalmodel> calificaciones =
          contentList.map((json) => Calfinalmodel.fromJson(json)).toList();

      // Obtener nombre del estudiante
      for (var calificacion in calificaciones) {
        EstudiantesModel? estudiante =
            await obtenerNombreEstudiantes(calificacion.fkEstudiante);
        if (estudiante != null) {
          calificacion.nombreEstudiante = estudiante.nombresEstudiante;
          calificacion.apellidoEstudiante = estudiante.apellidosEstudiante;
        } else {
          calificacion.nombreEstudiante = "No disponible";
          calificacion.apellidoEstudiante = "";
        }
      }

      return calificaciones;
    } else {
      throw Exception("Error al obtener las calificaciones");
    }
  }

  // Obtener nombre de los estudiantes
  Future<EstudiantesModel?> obtenerNombreEstudiantes(int estudiantesId) async {
    try {
      final response =
          await http.get(Uri.parse("$EstudianteUrl/$estudiantesId"));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return EstudiantesModel.fromJson(data);
      } else {
        print("Estudiante no encontrado");
        return null;
      }
    } catch (e) {
      print("Error al obtener estudiante: $e");
      return null;
    }
  }

  // Obtener nombre de la asignatura
  Future<Asignaturamodel?> obtenerAsignatura(int asignaturaId) async {
    try {
      final response = await http
          .get(Uri.parse("${Enlacesurl.asignaturaUrl}/$asignaturaId"));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return Asignaturamodel.fromJson(data);
      } else {
        print("Asignatura no encontrada");
        return null;
      }
    } catch (e) {
      print("Error al obtener asignatura: $e");
      return null;
    }
  }

  // Filtrar calificaciones por curso
  Future<List<Calfinalmodel>> obtenerCalificacionesPorCurso(int cursoId) async {
    final response = await http.get(Uri.parse("$baseUrl?cursoId=$cursoId"));
    print("Respuesta Api notas (${response.statusCode}):${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> contentList = jsonData['content'];

      List<Calfinalmodel> calificaciones =
          contentList.map((json) => Calfinalmodel.fromJson(json)).toList();

      for (var calificacion in calificaciones) {
        EstudiantesModel? estudiante =
            await obtenerNombreEstudiantes(calificacion.fkEstudiante);
        if (estudiante != null) {
          calificacion.nombreEstudiante = estudiante.nombresEstudiante;
          calificacion.apellidoEstudiante = estudiante.apellidosEstudiante;
        } else {
          calificacion.nombreEstudiante = "No disponible";
          calificacion.apellidoEstudiante = "";
        }
      }

      return calificaciones;
    } else {
      throw Exception("Error al obtener las calificaciones");
    }
  }
}
