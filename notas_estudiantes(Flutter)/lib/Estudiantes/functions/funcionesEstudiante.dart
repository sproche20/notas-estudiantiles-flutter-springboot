import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Funcionesestudiante {
  final Estudiantecontroller estudiantecontroller = Estudiantecontroller();
  /**-----------------Formulario------------------------------------------------- */
  final TextEditingController nombresEstudianteController =
      TextEditingController();
  final TextEditingController apellidosEstudianteController =
      TextEditingController();
  final TextEditingController nombresRepresanteController =
      TextEditingController();
  final TextEditingController edadEstudianteController =
      TextEditingController();
  int? selectCursoId;
  List<Cursosmodel> listaCursos = [];
  late BuildContext _context;
  late void Function(VoidCallback) _setState;
  Future<void> _cargarCursos() async {
    try {
      List<Cursosmodel> cursos = await estudiantecontroller.obtenerCursos();
      _setState(() {
        listaCursos = cursos;
      });
    } catch (e) {
      print("Error al cargar proyectos: $e");
    }
  }

  Future<void> registrarEstudiante() async {
    String edadTexto = edadEstudianteController.text.trim();
    int? edadEstudiante = int.tryParse(edadTexto);
    if (edadEstudiante == null || edadEstudiante < 5 || edadEstudiante > 18) {
      Customizarsnackbar.mostrarError(
        _context,
        "La edad del estudiante debe estar entre 5 y 18 años",
      );
      return;
    }

    String apellidoCompleto = apellidosEstudianteController.text.trim();
    List<String> partesApellido = apellidoCompleto.split(RegExp(r'\s+'));
    if (partesApellido.length < 2) {
      Customizarsnackbar.mostrarError(
          _context, "Por favor ingrese los Apellidos completos del estudiante");
      return;
    }
    if (nombresEstudianteController.text.isEmpty ||
        apellidoCompleto.isEmpty ||
        nombresRepresanteController.text.isEmpty ||
        selectCursoId == null ||
        edadTexto.isEmpty) {
      Customizarsnackbar.mostrarError(
          _context, "Por favor complete los campos");
      return;
    }
    EstudiantesModel nuevoEstudiante = EstudiantesModel(
        nombresEstudiante: nombresEstudianteController.text,
        apellidosEstudiante: apellidoCompleto,
        edadEstudiante: edadEstudiante,
        nombresRepresentante: nombresRepresanteController.text,
        fkCursos: selectCursoId!);
    try {
      bool exito =
          await estudiantecontroller.registrarEstudiante(nuevoEstudiante);
      if (exito) {
        Customizarsnackbar.mostrarExito(
            _context, 'Estudiante creado Correctamente');
        nombresEstudianteController.clear();
        apellidosEstudianteController.clear();
        nombresRepresanteController.clear();
        edadEstudianteController.clear();

        _setState(() {
          selectCursoId = null;
        });
        Navigator.pushNamed(
            _context, 'estudianteTable'); // Cerrar el formulario
      } else {
        Customizarsnackbar.mostrarError(
            _context, "Error al guardar al estudiante");
      }
    } catch (e) {
      Customizarsnackbar.mostrarError(
          _context, "Error inesperado al guardar estudiante ");
    }
  }

  /**Tabla Estudiante------------------------------------------------------------------------------- */
  final TextEditingController buscarController = TextEditingController();
  final bool mounted;
  Funcionesestudiante(this.mounted, this._setState);
  List<EstudiantesModel> estudiantes = [];
  List<EstudiantesModel> estudiantesFiltrados = [];
  bool isLoading = true;
  int _paginaActual = 0;
  final int _estudiantesPorPagina = 6;
  String primerNombre(String? nombreCompleto) {
    if (nombreCompleto == null || nombreCompleto.isEmpty) return "Desconocido";
    return nombreCompleto.split(" ").first;
  }

  String primerApellido(String? apellidoCompleto) {
    if (apellidoCompleto == null || apellidoCompleto.isEmpty) return "";
    return apellidoCompleto.split(" ").first;
  }

  Future<void> obtenerEstudiantes() async {
    try {
      List<EstudiantesModel> estudiantesObtenidos =
          await estudiantecontroller.obtenerEstudiantes();
      if (!mounted) return;
      await Future.wait(estudiantes.map((curso) async {
        final nombres = await Future.wait(
            [estudiantecontroller.obtenerNombreCurso(curso.fkCursos)]);
        curso.curso = nombres[0];
      }));
      if (!mounted) return; // ✅ Verificación antes de actualizar el estado
      _setState(() {
        estudiantes = estudiantesObtenidos;
        estudiantesFiltrados = estudiantesObtenidos;
        isLoading = false;
      });
    } catch (e) {
      print("Error al obtener Cursos:$e");
      if (!mounted) return;
      _setState(() {
        isLoading = false;
      });
    }
  }

  void filtrarEstudiantes(String query) {
    if (query.isEmpty) {
      _setState(() {
        estudiantesFiltrados = estudiantes;
      });
    } else {
      _setState(() {
        estudiantesFiltrados = estudiantes
            .where((estudiante) => estudiante.nombresEstudiante
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      });
    }
    _paginaActual = 0; // Reiniciar la paginación al filtrar
  }

  List<EstudiantesModel> obtenerEstudiantesPaginados() {
    int inicio = _paginaActual * _estudiantesPorPagina;
    if (inicio >= estudiantesFiltrados.length) {
      return [];
    }
    int fin = inicio + _estudiantesPorPagina;
    return estudiantesFiltrados.sublist(inicio,
        fin > estudiantesFiltrados.length ? estudiantesFiltrados.length : fin);
  }

  void _siguientePagina() {
    if ((_paginaActual + 1) * _estudiantesPorPagina <
        estudiantesFiltrados.length) {
      _setState(() {
        _paginaActual++;
      });
    }
  }

  void _paginaAnterior() {
    if (_paginaActual > 0) {
      _setState(() {
        _paginaActual--;
      });
    }
  }

  Future<void> eliminarEstudiante(
      BuildContext context, int estudianteId) async {
    try {
      bool eliminado =
          await estudiantecontroller.eliminarEstudiante(estudianteId);
      if (eliminado) {
        Customizarsnackbar.mostrarExito(
            context, "Estudiante eliminado con éxito");
        obtenerEstudiantes(); // Solo se llama si fue exitoso
      } else {
        Customizarsnackbar.mostrarError(
            context, "Error al eliminar al estudiante");
      }
      if (eliminado) obtenerEstudiantes();
    } catch (e) {
      print("Error: $e");
      Customizarsnackbar.mostrarError(
          context, "Error al eliminar al estudiante");
    }
  }

  // Método para mostrar el diálogo de confirmación
  void _mostrarConfirmacionEliminar(
      BuildContext context, EstudiantesModel estudiantes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmación"),
          content:
              Text("¿Estás seguro de que quieres eliminar a este estudiante?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo sin hacer nada
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                // Si se acepta, eliminamos el usuario
                if (estudiantes.id != null) {
                  eliminarEstudiante(context, estudiantes.id!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("ID de estudiante no válido")),
                  );
                }
                Navigator.of(context)
                    .pop(); // Cerrar el diálogo después de eliminar
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  Widget construirBotonesPaginacion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_paginaActual > 0)
          GestureDetector(
            onTap: _paginaAnterior,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF094263), // Blanco crema
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Text(
                "Anterior",
                style: TextStyle(
                  color: const Color.fromARGB(
                      255, 255, 255, 255), // Color del texto
                  fontSize: 16,
                ),
              ),
            ),
          ),
        SizedBox(width: 10),
        if ((_paginaActual + 1) * _estudiantesPorPagina <
            estudiantesFiltrados.length)
          GestureDetector(
            onTap: _siguientePagina,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF094263), // Blanco crema
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Text(
                "Siguiente",
                style: TextStyle(
                  color: const Color.fromARGB(
                      255, 255, 255, 255), // Color del texto
                  fontSize: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /**init general------------------------------------------------------------------------ */

  void init(BuildContext context, void Function(VoidCallback) setState) {
    _context = context;
    _setState = setState;
    _cargarCursos();
    obtenerEstudiantes();
    buscarController.addListener(() {
      filtrarEstudiantes(buscarController.text);
    });
  }
}
