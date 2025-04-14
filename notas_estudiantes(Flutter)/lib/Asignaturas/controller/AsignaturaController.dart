import 'dart:convert';

import 'package:notas_estudiantes/enlaces/Enlaces.dart';
import 'package:http/http.dart' as http;

class Asignaturacontroller {
  final String baseUrl = Enlacesurl.asignaturaUrl;
  //obtener todas las asignaturas
  Future<List<Asignaturamodel>> obtenerAsignatura() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Asignaturamodel.fromJson(json)).toList();
    } else {
      throw Exception('error al obtener las asignaturas');
    }
  }

  //crear nuevo asignatura
  Future<bool> crearAsignatura(Asignaturamodel asignatura) async {
    final response = await http.post(Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(asignatura.toJson()));
    print("Código de estado: ${response.statusCode}");
    print("Respuesta del servidor: ${response.body}");
    return response.statusCode == 201;
  }

  //actualizar Asignatura
  Future<bool> actualizarAsignatura(int id, Asignaturamodel asignatura) async {
    final response = await http.put(Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(asignatura.toJson()));
    return response.statusCode == 200;
  }

//eliminar
  Future<bool> eliminarAsignatura(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return true; // Usuario eliminado con éxito
      } else if (response.statusCode == 400) {
        print("Error: ${response.body}");
        throw Exception(
            "El usuario tiene asignaciones o gestiones de cambios activas.");
      } else if (response.statusCode == 404) {
        throw Exception("Usuario no encontrado.");
      } else {
        throw Exception("Error desconocido al eliminar usuario.");
      }
    } catch (e) {
      print("Error de conexión: $e");
      throw Exception("Error de conexión: $e");
    }
  }
}
