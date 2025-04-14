import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Calificacionasigformcontrolador {
  final Calporasigcontroller _apiController = Calporasigcontroller();

  int? selectedAsignaturaId;
  int? selectedEstudianteId;
  int? selectedCursoId;
  List<EstudiantesModel> listaEstudiantes = [];
  List<Cursosmodel> listaCursos = [];
  List<NotaAsignatura> notasList = [];
  List<Asignaturamodel> listaAsignaturas = [];

  late BuildContext _context;
  late void Function(VoidCallback) _setState;

  void init(BuildContext context, void Function(VoidCallback) setState) {
    _context = context;
    _setState = setState;
    _cargarCursos();
    _cargarEstudiantes();
    _cargarAsignaturas();
  }

  Future<void> _cargarCursos() async {
    try {
      listaCursos = await _apiController.obtenerCursos();
      _setState(() {});
    } catch (e) {
      print("Error al cargar los cursos: $e");
    }
  }

  Future<void> _cargarEstudiantes() async {
    try {
      listaEstudiantes = await _apiController.obtenerEstudiantes();
      _setState(() {});
    } catch (e) {
      print("Error al cargar los estudiantes: $e");
    }
  }

  Future<void> _cargarAsignaturas() async {
    try {
      listaAsignaturas = await _apiController.obtenerasignaturas();
      _setState(() {});
    } catch (e) {
      print("Error al cargar las asignaturas: $e");
    }
  }

  bool puedeSeleccionarEstudiante() =>
      listaEstudiantes.isNotEmpty && selectedCursoId != null;

  void onCursoSeleccionado(int? cursoId) async {
    selectedCursoId = cursoId;
    selectedEstudianteId = null;
    listaEstudiantes = [];
    _setState(() {});
    try {
      listaEstudiantes =
          await _apiController.obtenerEstudiantesPorCurso(cursoId!);
      _setState(() {});
    } catch (e) {
      print("Error al filtrar estudiantes por curso: $e");
    }
  }

  void onEstudianteSeleccionado(int? id) {
    selectedEstudianteId = id;
    _setState(() {});
  }

  void onAsignaturaSeleccionada(int? id) {
    selectedAsignaturaId = id;
    final asignatura = listaAsignaturas.firstWhere((a) => a.id == id);
    _agregarAsignatura(asignatura);
  }

  void _agregarAsignatura(Asignaturamodel asignatura) {
    if (!notasList.any((n) => n.fkAsignatura == asignatura.id)) {
      notasList.add(NotaAsignatura(fkAsignatura: asignatura.id!, nota: 0.0));
      _setState(() {});
    }
  }

  void agregarOtraAsignatura() {
    selectedAsignaturaId = null;
    _setState(() {});
  }

  void actualizarNota(int index, String value) {
    notasList[index].nota = double.tryParse(value) ?? 0.0;
  }

  String obtenerNombreAsignatura(int idAsignatura) {
    final asig = listaAsignaturas.firstWhere(
      (a) => a.id == idAsignatura,
      orElse: () => Asignaturamodel(id: 0, nombreAsignatura: 'Desconocida'),
    );
    return asig.nombreAsignatura;
  }

  Future<void> guardarCalificacionAsignatura() async {
    if (selectedCursoId == null || selectedEstudianteId == null) {
      Customizarsnackbar.mostrarError(
          _context, 'Por favor, complete todos los campos');
      return;
    }
    final nueva = CalPorAsigModel(
      fkEstudiante: selectedEstudianteId!,
      fkCurso: selectedCursoId!,
      notas: notasList,
    );

    try {
      bool exito = await _apiController.ingresarCalificacion(nueva);
      if (exito) {
        Customizarsnackbar.mostrarExito(
            _context, 'Notas registradas con éxito');

        selectedCursoId = null;
        selectedEstudianteId = null;
        notasList.clear();
        Navigator.pushNamed(_context, 'filtroCurso'); // Cerrar el formulario

        _setState(() {});
      } else {
        Customizarsnackbar.mostrarError(
            _context, 'Error al registrar las notas');
      }
    } catch (e) {
      Customizarsnackbar.mostrarError(_context, 'Error al registrar las notas');
    }
  }
}
