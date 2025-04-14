import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Funcionesasignatura {
  final Asignaturacontroller _asignaturacontroller = Asignaturacontroller();
  /***Formulario-------------------------------------------------------------------------------------------------------------------------------- */
  final TextEditingController NombreAsignatura = TextEditingController();
  late BuildContext _context;
  void Function(VoidCallback) _setState;

  Future<void> guardarAsignatura() async {
    if (NombreAsignatura.text.isEmpty) {
      Customizarsnackbar.mostrarError(
          _context, 'Por favor complete los campos ');
      return;
    }
    Asignaturamodel nuevaAsignatura =
        Asignaturamodel(nombreAsignatura: NombreAsignatura.text);
    try {
      bool exito = await _asignaturacontroller.crearAsignatura(nuevaAsignatura);
      if (exito) {
        // Aquí podrías llamar a la función para guardar y luego:
        Customizarsnackbar.mostrarExito(
            _context, 'Asignatura  guardada con éxito');
        NombreAsignatura.clear();
        Navigator.pushNamed(
            _context, 'asignaturaTabla'); // Cerrar el formulario
      } else {
        Customizarsnackbar.mostrarError(
            _context, "Error al guardar la asignatura");
      }
    } catch (e) {
      Customizarsnackbar.mostrarError(
          _context, "Error inesperado al guardar la asignatura $e");
    }
  }

/**Tabla Asignatura----------------------------------------------------------- ---------------------------------------------------------------*/
  final TextEditingController buscarController = TextEditingController();
  final bool mounted;
  Funcionesasignatura(this.mounted, this._setState);

  List<Asignaturamodel> asignaturas = [];
  List<Asignaturamodel> asignaturasFiltradas = [];
  bool isLoading = true;
  //variable de paginacion
  int _paginaActual = 0;
  final int _asignaturasPorPagina = 6;

  Future<void> obtenerAsignaturas() async {
    try {
      List<Asignaturamodel> asignatura =
          await _asignaturacontroller.obtenerAsignatura();
      if (!mounted) return; // ✅ Verificación antes de actualizar el estado
      _setState(() {
        asignaturas = asignatura;
        asignaturasFiltradas = asignatura;
        isLoading = false;
      });
    } catch (e) {
      print("Error al obtener Asignaturas:$e");
      if (!mounted) return;
      _setState(() {
        isLoading = false;
      });
    }
  }

  void filtrarAsignaturas(String query) {
    if (query.isEmpty) {
      _setState(() {
        asignaturasFiltradas = asignaturas;
      });
    } else {
      _setState(() {
        asignaturasFiltradas = asignaturas
            .where((asignatura) => asignatura.nombreAsignatura
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      });
    }
    _paginaActual = 0; // Reiniciar la paginación al filtrar
  }

  List<Asignaturamodel> obtenerAsignaturasPaginadas() {
    int inicio = _paginaActual * _asignaturasPorPagina;
    if (inicio >= asignaturasFiltradas.length) {
      return [];
    }
    int fin = inicio + _asignaturasPorPagina;
    return asignaturasFiltradas.sublist(inicio,
        fin > asignaturasFiltradas.length ? asignaturasFiltradas.length : fin);
  }

  void _siguientePagina() {
    if ((_paginaActual + 1) * _asignaturasPorPagina <
        asignaturasFiltradas.length) {
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

  Future<void> _eliminarAsignatura(
      BuildContext context, int asignaturaId) async {
    try {
      bool eliminado =
          await _asignaturacontroller.eliminarAsignatura(asignaturaId);

      if (eliminado) {
        Customizarsnackbar.mostrarExito(
            context, "Asignatura eliminada con éxito");
        obtenerAsignaturas(); // Solo se llama si fue exitoso
      } else {
        Customizarsnackbar.mostrarError(
            context, "Error al eliminar la asignatura");
      }
      if (eliminado) obtenerAsignaturas();
    } catch (e) {
      print("Error: $e");
      Customizarsnackbar.mostrarError(
          context, "Error al eliminar la asignatura");
    }
  }

  // Método para mostrar el diálogo de confirmación
  void mostrarConfirmacionEliminar(
      BuildContext context, Asignaturamodel asignatura) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmación"),
          content:
              Text("¿Estás seguro de que quieres eliminar a esta asignatura?"),
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
                if (asignatura.id != null) {
                  _eliminarAsignatura(context, asignatura.id!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("ID de asignatura no válida")),
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
        if ((_paginaActual + 1) * _asignaturasPorPagina <
            asignaturasFiltradas.length)
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
                  color: Color.fromARGB(255, 255, 255, 255), // Color del texto
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
    obtenerAsignaturas();
    buscarController.addListener(() {
      filtrarAsignaturas(buscarController.text);
    });
  }
}
