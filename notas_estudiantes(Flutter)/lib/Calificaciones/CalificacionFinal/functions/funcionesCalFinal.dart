import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Funcionescalfinal {
  final Calfinalcontroller calfinalcontroller = Calfinalcontroller();
  late BuildContext _context;
  late void Function(VoidCallback) _setState;
  final bool mounted;
  Funcionescalfinal(this.mounted, this._setState);
  /**Tabla notas finales */
  final TextEditingController buscarController = TextEditingController();
  List<Calfinalmodel> calificacionFinal = [];
  List<Calfinalmodel> calificacionFinalFiltrada = [];
  bool isLoading = true;
  //variable de paginacion
  int _paginaActual = 0;
  final int _calificacionPorPagina = 6;

  String primerNombre(String? nombreCompleto) {
    if (nombreCompleto == null || nombreCompleto.isEmpty) return "Desconocido";
    return nombreCompleto.split(" ").first;
  }

  String primerApellido(String? apellidoCompleto) {
    if (apellidoCompleto == null || apellidoCompleto.isEmpty) return "";
    return apellidoCompleto.split(" ").first;
  }

  void filtrarNotasFinales(String query) {
    String normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      calificacionFinalFiltrada = List.from(calificacionFinal);
    } else {
      calificacionFinalFiltrada = calificacionFinal.where((estudiante) {
        final nombre = estudiante.nombreEstudiante ?? "";
        final apellido = estudiante.apellidoEstudiante ?? "";
        return nombre.toLowerCase().contains(normalizedQuery) ||
            apellido.toLowerCase().contains(normalizedQuery);
      }).toList();
    }
    _paginaActual = 0;
    _setState(() {}); // <- importante si quieres que se actualice al escribir
  }

  List<Calfinalmodel> obtenerCalificacionPaginada() {
    int inicio = _paginaActual * _calificacionPorPagina;
    if (inicio >= calificacionFinalFiltrada.length) {
      return [];
    }
    int fin = inicio + _calificacionPorPagina;
    return calificacionFinalFiltrada.sublist(
        inicio,
        fin > calificacionFinalFiltrada.length
            ? calificacionFinalFiltrada.length
            : fin);
  }

  void _siguientePagina() {
    if ((_paginaActual + 1) * _calificacionPorPagina <
        calificacionFinalFiltrada.length) {
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
        if ((_paginaActual + 1) * _calificacionPorPagina <
            calificacionFinalFiltrada.length)
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

  /**init general ----------------------------------------------------------------*/

  void init(BuildContext context, void Function(VoidCallback) setState) {
    _context = context;
    _setState = setState;
    //agregar listener al campo de busqueda
    buscarController.addListener(() {
      filtrarNotasFinales(buscarController.text);
    });
  }
}
