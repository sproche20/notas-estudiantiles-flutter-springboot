import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Funcionesdocente {
  final Docentecontroller docentecontroller = Docentecontroller();
/**----------------------------Formulario------------------------------------------------------------------------- */
  final TextEditingController nombresDocenteController =
      TextEditingController();
  final TextEditingController apellidosDocenteController =
      TextEditingController();
  final TextEditingController especialidadDocenteController =
      TextEditingController();
  int? selectedAsignaturaId;
  List<Asignaturamodel> listaAsignaturas = [];
  late BuildContext _context;
  late void Function(VoidCallback) _setState;

  Future<void> _cargarAsignaturas() async {
    try {
      List<Asignaturamodel> asignaturas =
          await docentecontroller.obtenerasignaturas();
      _setState(() {
        listaAsignaturas = asignaturas;
      });
    } catch (e) {
      print("Error al cargar Asignaturas: $e");
    }
  }

  Future<void> guardarDocente() async {
    String apellidoCompleto =
        apellidosDocenteController.text.trim(); // Elimina espacios extra
    //verificar que apellido tenga al menos dos palabras
    List<String> partesApellido = apellidoCompleto.split(RegExp(r'\s+'));
    if (partesApellido.length < 2) {
      Customizarsnackbar.mostrarError(
          _context, "Por favor ingrese los Apellidos completos del docente ");
      return; //sale de la funcion sin guardar
    }

    if (nombresDocenteController.text.isEmpty ||
        apellidoCompleto.isEmpty ||
        especialidadDocenteController.text.isEmpty ||
        selectedAsignaturaId == null) {
      Customizarsnackbar.mostrarError(
          _context, "Por favor complete los campos");
      return;
    }
    Docentemodel nuevoDocente = Docentemodel(
        nombresDocente: nombresDocenteController.text,
        apellidosDocente: apellidoCompleto,
        especialidadDocente: especialidadDocenteController.text,
        fkAsignatura: selectedAsignaturaId!);
    try {
      bool exito = await docentecontroller.crearDocente(nuevoDocente);
      if (exito) {
        Customizarsnackbar.mostrarExito(
            _context, 'Docente creado Correctamente');
        nombresDocenteController.clear();
        apellidosDocenteController.clear();
        especialidadDocenteController.clear();
        _setState(() {
          selectedAsignaturaId = null;
        });
        Navigator.pushNamed(_context, 'docentesTable'); // Cerrar el formulario
      } else {
        Customizarsnackbar.mostrarError(
            _context, "Error al guardar al docente");
      }
    } catch (e) {
      Customizarsnackbar.mostrarError(
          _context, "Error inesperado al guardar docente ");
    }
  }

/*Tabla Docentes------------------------------------------------------------------------------ */
  final TextEditingController buscarController = TextEditingController();
  List<Docentemodel> _docentes = [];
  List<Docentemodel> docentesFiltrados = [];
  bool isLoading = true;
  final bool mounted;
  Funcionesdocente(this.mounted, this._setState);

  String primerNombre(String? nombreCompleto) {
    if (nombreCompleto == null || nombreCompleto.isEmpty) return "Desconocido";
    return nombreCompleto.split(" ").first;
  }

  String primerApellido(String? apellidoCompleto) {
    if (apellidoCompleto == null || apellidoCompleto.isEmpty) return "";
    return apellidoCompleto.split(" ").first;
  }

  //variable de paginacion
  int _paginaActual = 0;
  final int _docentesPorPagina = 8;
  Future<void> obtenerDocentes() async {
    try {
      List<Docentemodel> docentes = await docentecontroller.obtenerDocentes();
      if (!mounted) return;

      await Future.wait(docentes.map((asignatura) async {
        final nombres = await Future.wait([
          docentecontroller.obtenerNombreAsignaturas(asignatura.fkAsignatura)
        ]);
        asignatura.nombreAsignatura = nombres[0];
      }));
      if (!mounted) return; // ✅ Verificación antes de actualizar el estado
      _setState(() {
        _docentes = docentes;
        docentesFiltrados = docentes;
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

  void _filtrarDocentes(String query) {
    if (query.isEmpty) {
      _setState(() {
        docentesFiltrados = _docentes;
      });
    } else {
      _setState(() {
        docentesFiltrados = _docentes
            .where((docente) => docente.nombresDocente
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      });
    }
    _paginaActual = 0; // Reiniciar la paginación al filtrar
  }

  List<Docentemodel> obtenerDocentesPaginados() {
    int inicio = _paginaActual * _docentesPorPagina;
    if (inicio >= docentesFiltrados.length) {
      return [];
    }
    int fin = inicio + _docentesPorPagina;
    return docentesFiltrados.sublist(inicio,
        fin > docentesFiltrados.length ? docentesFiltrados.length : fin);
  }

  void _siguientePagina() {
    if ((_paginaActual + 1) * _docentesPorPagina < docentesFiltrados.length) {
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

  Future<void> eliminarDocentes(BuildContext context, int cursoId) async {
    try {
      bool eliminado = await docentecontroller.eliminarDocente(cursoId);
      if (eliminado) {
        Customizarsnackbar.mostrarExito(context, "Docente eliminado con éxito");
        obtenerDocentes(); // Solo se llama si fue exitoso
      } else {
        Customizarsnackbar.mostrarError(
            context, "No se puede eliminar al docente, es tutor de un curso");
      }
      if (eliminado) obtenerDocentes();
    } catch (e) {
      print("Error: $e");
      Customizarsnackbar.mostrarError(
          context, "No se puede eliminar al docente, es tutor de un curso");
    }
  }

  // Método para mostrar el diálogo de confirmación
  void mostrarConfirmacionEliminar(BuildContext context, Cursosmodel curso) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmación"),
          content:
              Text("¿Estás seguro de que quieres eliminar a este usuario?"),
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
                  eliminarDocentes(context, curso.id!);
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
                    color: const Color.fromARGB(195, 0, 0, 0),
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
        if ((_paginaActual + 1) * _docentesPorPagina < docentesFiltrados.length)
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

  /**init general---------------------------------------------------------------------- */

  void init(BuildContext context, void Function(VoidCallback) setState) {
    _context = context;
    _setState = setState;
    _cargarAsignaturas();
    obtenerDocentes();
    buscarController.addListener(() {
      _filtrarDocentes(buscarController.text);
    });
  }
}
