import 'package:notas_estudiantes/enlaces/Enlaces.dart';
import 'package:http/http.dart' as http;

class Estudiantecontroller {
  final String baseUrl = Enlacesurl.estudianteUrl;
  final String CursosUrl = Enlacesurl.cursosUrl;
  //listar Estudiantes
  Future<List<EstudiantesModel>> obtenerEstudiantes() async {
    final response = await http.get(Uri.parse(baseUrl));
    print(
        "Respuesta api Estudiantes (${response.statusCode}):${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<EstudiantesModel> estudiantes =
          jsonData.map((json) => EstudiantesModel.fromJson(json)).toList();
      //obtener nombres de los cursos
      for (var estudiante in estudiantes) {
        estudiante.curso = await obtenerNombreCurso(estudiante.fkCursos);
      }
      return estudiantes;
    } else {
      throw Exception("Error al obtener los estudiantes");
    }
  }

  //registrar estudiante
  Future<bool> registrarEstudiante(EstudiantesModel estudiantes) async {
    final jsonBody = jsonEncode(estudiantes.toJson());
    print("Estudiante a enviar: $jsonBody");

    final response = await http.post(Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(estudiantes.toJson()));
    print("Código de estado: ${response.statusCode}");
    print("Respuesta del servidor: ${response.body}");
    return response.statusCode == 200 || response.statusCode == 201;
  }

  //actualizar datos estudiante
  //actualizarTarea
  Future<bool> actualizarEstudiantes(
      int id, EstudiantesModel estudiantes) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(estudiantes
            .toJson()), // Asegúrate de que `toJson()` esté bien implementado
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error en la respuesta del servidor: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error al actualizar los datos: $e");
      return false;
    }
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

  //eliminar Estudiante
  Future<bool> eliminarEstudiante(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    return response.statusCode == 204;
  }

  //obtener nombre del curso
  Future<String> obtenerNombreCurso(int cursoId) async {
    try {
      final response = await http.get(Uri.parse("$CursosUrl/$cursoId"));
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
}
