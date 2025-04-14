import 'package:http/http.dart' as http;
import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Cursocontroller {
  final String baseUrl = Enlacesurl.cursosUrl;
  final String DocenteUrl = Enlacesurl.docenteUrl;
  //obtener todas las listas
  Future<List<Cursosmodel>> obtenerCursos() async {
    final response = await http.get(Uri.parse(baseUrl));
    print("Respuesta api notas (${response.statusCode}):${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Cursosmodel> cursos =
          jsonData.map((json) => Cursosmodel.fromJson(json)).toList();
      //obtener nombre de los docentes
      for (var curso in cursos) {
        Docentemodel? docente = await obtenerNombresDocentes(curso.fkDocente);
        if (docente != null) {
          curso.nombreDocente = docente.nombresDocente;
          curso.apellidoDocente = docente.apellidosDocente;
        } else {
          curso.nombreDocente = "No disponible";
          curso.apellidoDocente = "";
        }
      }
      return cursos;
    } else {
      throw Exception("Error al obtener los cursos");
    }
  }

  //crear cursos
  Future<bool> crearCurso(Cursosmodel cursos) async {
    final response = await http.post(Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(cursos.toJson()));

    print("Código de estado: ${response.statusCode}");
    print("Respuesta del servidor: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 400) {
      throw Exception(response.body); // Captura el mensaje específico
    } else {
      throw Exception("Error desconocido al guardar el curso");
    }
  }

  //actualizar
  Future<bool> actualizarCurso(int id, Cursosmodel cursos) async {
    try {
      final response = await http.put(Uri.parse('$baseUrl/$id'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(cursos.toJson()));

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        var mensaje = response.body;
        print("Error del servidor (400): $mensaje");
        throw Exception(mensaje); // puedes capturarlo luego en la vista
      } else {
        print("Error inesperado: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error al actualizar cursos: $e");
      return false;
    }
  }

  //eliminar Cursos
  Future<bool> eliminarCursos(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        // Mostrar el mensaje de error directamente en el UI
        print("Error ${response.body}");
        throw Exception(response.body); // Ahora pasamos el mensaje de la API
      } else if (response.statusCode == 404) {
        throw Exception("Curso no encontrado");
      } else {
        throw Exception("Error desconocido al eliminar el curso");
      }
    } catch (e) {
      print("Error de conexión: $e");
      throw Exception("Error de conexión: $e");
    }
  }

  //listar docente
  Future<List<Docentemodel>> obtenerDocente() async {
    final response = await http.get(Uri.parse(DocenteUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Docentemodel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener la lista de docentes');
    }
  }

  //obtener nombres docentes
  Future<Docentemodel?> obtenerNombresDocentes(int docenteId) async {
    try {
      final response = await http.get(Uri.parse("$DocenteUrl/$docenteId"));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return Docentemodel.fromJson(data);
      } else {
        print("Docente no encontrado");
        return null;
      }
    } catch (e) {
      print("Error al obtener docente: $e");
      return null;
    }
  }
}
