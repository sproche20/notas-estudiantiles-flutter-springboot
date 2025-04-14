import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Calificacionasignaturaedit extends StatefulWidget {
  final CalPorAsigModel calificacionAsignatura;
  const Calificacionasignaturaedit(
      {super.key, required this.calificacionAsignatura});

  @override
  State<Calificacionasignaturaedit> createState() =>
      _CalificacionasignaturaeditState();
}

class _CalificacionasignaturaeditState
    extends State<Calificacionasignaturaedit> {
  final _formKey = GlobalKey<FormState>();
  final Calporasigcontroller _apiController = Calporasigcontroller();

  List<Cursosmodel> listacursos = [];
  List<EstudiantesModel> listaestudiantes = [];
  List<Asignaturamodel> listaasignaturas = [];
  List<NotaAsignatura> notaList = [];

  int? selectedCursoId;
  int? selectedEstudianteId;

  late BuildContext _context;
  late StateSetter _setState;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _context = context;
    _setState = setState;
    _cargarDatos();
    selectedCursoId = widget.calificacionAsignatura.fkCurso;
    selectedEstudianteId = widget.calificacionAsignatura.fkEstudiante;
    notaList = List<NotaAsignatura>.from(widget.calificacionAsignatura.notas);
  }

  Future<void> _cargarDatos() async {
    try {
      var cursos = await _apiController.obtenerCursos();
      var estudiantes = await _apiController.obtenerEstudiantes();
      var asignaturas = await _apiController.obtenerasignaturas();

      setState(() {
        listacursos = cursos;
        listaestudiantes = estudiantes;
        listaasignaturas = asignaturas;
      });
    } catch (e) {
      print("Error al cargar los datos: $e");
    }
  }

  Future<void> _actualizarCalificaciones() async {
    if (_formKey.currentState!.validate()) {
      final nuevasNotas = CalPorAsigModel(
          id: widget.calificacionAsignatura.id,
          fkEstudiante: selectedEstudianteId!,
          fkCurso: selectedCursoId!,
          notas: notaList);
      try {
        await _apiController.actualizarCalificaciones(
            nuevasNotas.id!, nuevasNotas);
        if (mounted) {
          Customizarsnackbar.mostrarExito(
              context, 'Calificaciones actualizadas correctamente');
          Navigator.pushNamed(context, 'filtroCurso'); // Cerrar el formulario
        }
      } catch (e) {
        if (mounted) {
          Customizarsnackbar.mostrarError(
              context, 'Error al actualizar las calificaciones');
        }
      }
    }
  }

  Future<String> _obtenerNombreAsignatura(int? id) async {
    if (id == null) return 'Desconocida';
    return await _apiController.obtenerNombreAsignaturas(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF094263), // Color 2
        title: Text(
          'Actualizar Notas por Asignatura',
          style: GoogleFonts.gabarito(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: listacursos.isEmpty ||
                  listaestudiantes.isEmpty ||
                  listaasignaturas.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Curso del estudiante',
                          labelStyle:
                              TextStyle(color: Color(0xFF094263)), // Color 2
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.menu_book_rounded,
                              color: Color(0xFF094263)), // Color 2
                        ),
                        value: selectedCursoId,
                        items: listacursos.map((Cursosmodel cursos) {
                          return DropdownMenuItem<int>(
                            value: cursos.id,
                            child: Text(
                              cursos.curso,
                              style: TextStyle(
                                  color: Color(0xFF094263)), // Color 2
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCursoId = value;
                          });
                        },
                        menuMaxHeight: 200, // Limita la altura máxima del menú
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Estudiante',
                          labelStyle:
                              TextStyle(color: Color(0xFF094263)), // Color 2
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.menu_book_rounded,
                              color: Color(0xFF094263)), // Color 2
                        ),
                        value: selectedEstudianteId,
                        items: listaestudiantes
                            .map((EstudiantesModel estudiantes) {
                          return DropdownMenuItem<int>(
                            value: estudiantes.id,
                            child: Text(
                              estudiantes.nombresEstudiante,
                              style: TextStyle(
                                  color: Color(0xFF094263)), // Color 2
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedEstudianteId = value;
                          });
                        },
                        menuMaxHeight: 200, // Limita la altura máxima del menú
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Notas por Asignatura',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: notaList.length,
                        itemBuilder: (context, index) {
                          final nota = notaList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder<String>(
                                    future: _obtenerNombreAsignatura(
                                        nota.fkAsignatura),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Text(
                                            'Cargando asignaturas...');
                                      } else if (snapshot.hasError) {
                                        return const Text(
                                            'Error al cargar las asignaturas');
                                      } else {
                                        return Text(
                                          snapshot.data ?? 'Sin Nombre',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        );
                                      }
                                    }),
                                TextFormField(
                                  initialValue: nota.nota.toString(),
                                  decoration:
                                      const InputDecoration(labelText: 'Nota'),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'ingrese una nota';
                                    }
                                    final n = double.tryParse(value);
                                    if (n == null || n < 0 || n > 10) {
                                      return 'Nota no valida(0-10)';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    final notaNum = double.tryParse(value);
                                    if (notaNum != null) {
                                      setState(() {
                                        nota.nota = notaNum;
                                      });
                                    }
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _actualizarCalificaciones,
                        icon: const Icon(Icons.save),
                        label: const Text(
                          'Actualizar',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16)),
                      )
                    ],
                  ))),
    );
  }
}
