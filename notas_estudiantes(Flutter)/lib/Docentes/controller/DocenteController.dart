import 'package:notas_estudiantes/enlaces/Enlaces.dart';
import 'package:http/http.dart' as http;

class Docentecontroller {
  final String baseUrl = Enlacesurl.docenteUrl;
  final String AsignaturaUrl = Enlacesurl.asignaturaUrl;
  //listar Docentes
  Future<List<Docentemodel>> obtenerDocentes() async {
    final response = await http.get(Uri.parse(baseUrl));
    print("Respuesta api Docente (${response.statusCode}):${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Docentemodel> docentes =
          jsonData.map((json) => Docentemodel.fromJson(json)).toList();

      //obtener nombres de los proyectos
      for (var docente in docentes) {
        docente.nombreAsignatura =
            await obtenerNombreAsignaturas(docente.fkAsignatura);
      }
      return docentes;
    } else {
      throw Exception("Error al obtener los docentes");
    }
  }

  //crear docente
  Future<bool> crearDocente(Docentemodel docente) async {
    final response = await http.post(Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(docente.toJson()));
    print("Código de estado: ${response.statusCode}");
    print("Respuesta del servidor: ${response.body}");
    return response.statusCode == 200 || response.statusCode == 201;
  }

  //actualizar Docente
  Future<bool> actualizarDocente(int id, Docentemodel docente) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(docente
            .toJson()), // Asegúrate de que `toJson()` esté bien implementado
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error en la respuesta del servidor: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error al actualizar el docente: $e");
      return false;
    }
  }

  //eliminar docente
  Future<bool> eliminarDocente(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return true; // Usuario eliminado con éxito
      } else if (response.statusCode == 400) {
        print("Error: ${response.body}");
        throw Exception("El Docente es tutor de un curso.");
      } else if (response.statusCode == 404) {
        throw Exception("Docente no encontrado.");
      } else {
        throw Exception("Error desconocido al eliminar el Docente.");
      }
    } catch (e) {
      print("Error de conexión: $e");
      throw Exception("Error de conexión: $e");
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
  Future<String> obtenerNombreAsignaturas(int asignaturaId) async {
    try {
      final response =
          await http.get(Uri.parse("$AsignaturaUrl/$asignaturaId"));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data["nombreAsignatura"] ?? "asignaturas no encontrada";
      } else {
        return "asignatura no encontrado";
      }
    } catch (e) {
      return "Error al obtener asignaturas";
    }
  }
}
