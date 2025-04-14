import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Funcionescurso {
  /**Formulario--------------------------------------------------------------------------------------- */
  final Cursocontroller cursocontroller = Cursocontroller();
  final TextEditingController nombreCursoController = TextEditingController();
  int? selectDocenteId;
  List<Docentemodel> listarDocentes = [];
  late BuildContext _context;
  late void Function(VoidCallback) _setState;

  Future<void> _cargarDocentes() async {
    try {
      List<Docentemodel> docentes = await cursocontroller.obtenerDocente();
      _setState(() {
        listarDocentes = docentes;
      });
    } catch (e) {
      Customizarsnackbar.mostrarError(_context, 'Error al cargar docentes.');
      print("Error al cargar Docentes: $e");
    }
  }

  Future<void> guardarCurso() async {
    if (nombreCursoController.text.isEmpty || selectDocenteId == null) {
      Customizarsnackbar.mostrarError(
          _context, 'Por favor complete los campos');
      return;
    }
    Cursosmodel nuevoCurso = Cursosmodel(
      curso: nombreCursoController.text,
      fkDocente: selectDocenteId!,
    );
    try {
      bool exito = await cursocontroller.crearCurso(nuevoCurso);
      if (exito) {
        // Aquí podrías llamar a la función para guardar y luego:
        Customizarsnackbar.mostrarExito(_context, 'Curso guardado con éxito');
        nombreCursoController.clear();
        _setState(() {
          selectDocenteId = null;
        });

        // Regresar a la pantalla de tabla y actualizar la lista
        Navigator.pushNamed(_context, 'cursosTable'); // Cerrar el formulario
        // Puedes llamar a un método de recarga en la tabla si es necesario.
      } else {
        Customizarsnackbar.mostrarError(_context, 'Error al guardar el curso');
      }
    } catch (e) {
      String mensajeError = e.toString();

      if (mensajeError.contains("ya está asignado a otro curso")) {
        Customizarsnackbar.mostrarError(_context,
            "El docente ya tiene asignado un curso. Por favor, elija otro docente.");
      } else {
        Customizarsnackbar.mostrarError(_context,
            "El docente ya tiene asignado un curso. Por favor, elija otro docente.");
      }

      print("Error inesperado al guardar curso: $e");
    }
  }

  /**Tabla Cursos----------------------------------------------------------------- */
  final TextEditingController buscarController = TextEditingController();
  final bool mounted;
  Funcionescurso(this.mounted, this._setState);
  List<Cursosmodel> cursos = [];
  List<Cursosmodel> cursosFiltrados = [];
  bool isLoading = true;
  //variable de paginacion
  int _paginaActual = 0;
  final int _cursosPorPagina = 6;
  String primerNombre(String? nombreCompleto) {
    if (nombreCompleto == null || nombreCompleto.isEmpty) return "Desconocido";
    return nombreCompleto.split(" ").first;
  }

  String primerApellido(String? apellidoCompleto) {
    if (apellidoCompleto == null || apellidoCompleto.isEmpty) return "";
    return apellidoCompleto.split(" ").first;
  }

  Future<void> obtenerCursos() async {
    try {
      List<Cursosmodel> cursosObtenidos = await cursocontroller.obtenerCursos();
      if (!mounted) return;
      await Future.wait(cursos.map((cursos) async {
        final docente =
            await cursocontroller.obtenerNombresDocentes(cursos.fkDocente);
        if (docente != null) {
          cursos.nombreDocente = docente.nombresDocente;
        }
      }));

      if (!mounted) return; // ✅ Verificación antes de actualizar el estado
      _setState(() {
        cursos = cursosObtenidos;
        cursosFiltrados = cursosObtenidos;
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

  void filtrarCursos(String query) {
    if (query.isEmpty) {
      _setState(() {
        cursosFiltrados = cursos;
      });
    } else {
      _setState(() {
        cursosFiltrados = cursos
            .where((curso) =>
                curso.curso.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
    _paginaActual = 0; // Reiniciar la paginación al filtrar
  }

  List<Cursosmodel> obtenerCursosPaginados() {
    int inicio = _paginaActual * _cursosPorPagina;
    if (inicio >= cursosFiltrados.length) {
      return [];
    }
    int fin = inicio + _cursosPorPagina;
    return cursosFiltrados.sublist(
        inicio, fin > cursosFiltrados.length ? cursosFiltrados.length : fin);
  }

  void _siguientePagina() {
    if ((_paginaActual + 1) * _cursosPorPagina < cursosFiltrados.length) {
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

  Future<void> eliminarCurso(BuildContext context, int cursoId) async {
    try {
      bool eliminado = await cursocontroller.eliminarCursos(cursoId);
      if (eliminado) {
        Customizarsnackbar.mostrarExito(context, "Curso eliminado con éxito");
        obtenerCursos(); // Solo se llama si fue exitoso
      } else {
        Customizarsnackbar.mostrarError(context, "Error al eliminar el curso");
      }
      if (eliminado) obtenerCursos();
    } catch (e) {
      print("Error: $e");
      // Este bloque ahora maneja el error desde el backend
      if (e is Exception) {
        Customizarsnackbar.mostrarError(
            context, e.toString()); // Mostrar el error específico
      } else {
        Customizarsnackbar.mostrarError(context,
            "Error al eliminar el curso. Elimínelos primero los estudiantes registrados en este curso.");
      }
    }
  }

  // Método para mostrar el diálogo de confirmación
  void mostrarConfirmacionEliminar(BuildContext context, Cursosmodel curso) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmación"),
          content: Text(
              "¿Estás seguro de que quieres eliminar a este curso(Se eliminaran automaticamente las notas de los estudiantes de ese curso)?"),
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
                if (curso.id != null) {
                  eliminarCurso(context, curso.id!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("ID de curso no válido")),
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
                      255, 245, 245, 245), // Color del texto
                  fontSize: 16,
                ),
              ),
            ),
          ),
        SizedBox(width: 10),
        if ((_paginaActual + 1) * _cursosPorPagina < cursosFiltrados.length)
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

  /**init general */

  void init(BuildContext context, void Function(VoidCallback) setState) {
    _context = context;
    _setState = setState;
    obtenerCursos();
    buscarController.addListener(() {
      filtrarCursos(buscarController.text);
    });
    _cargarDocentes();
  }
}
