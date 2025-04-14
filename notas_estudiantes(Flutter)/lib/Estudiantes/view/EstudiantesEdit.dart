import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Estudiantesedit extends StatefulWidget {
  final EstudiantesModel estudiantes;
  const Estudiantesedit({super.key, required this.estudiantes});

  @override
  State<Estudiantesedit> createState() => _EstudianteseditState();
}

class _EstudianteseditState extends State<Estudiantesedit> {
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
  final Estudiantecontroller estudiantecontroller = Estudiantecontroller();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cargarCursos();

    nombresEstudianteController.text = widget.estudiantes.nombresEstudiante;
    apellidosEstudianteController.text = widget.estudiantes.apellidosEstudiante;
    nombresRepresanteController.text = widget.estudiantes.nombresRepresentante;
    edadEstudianteController.text =
        widget.estudiantes.edadEstudiante.toString();
    selectCursoId = widget.estudiantes.fkCursos;
  }

  Future<void> _cargarCursos() async {
    try {
      List<Cursosmodel> cursos = await estudiantecontroller.obtenerCursos();
      setState(() {
        listaCursos = cursos;
      });
    } catch (e) {
      print("Error al cargar proyectos: $e");
    }
  }

  Future<void> actualizar() async {
    String edadTexto = edadEstudianteController.text.trim();
    int? edadEstudiante = int.tryParse(edadTexto);
    if (edadEstudiante == null || edadEstudiante < 5 || edadEstudiante > 18) {
      Customizarsnackbar.mostrarError(
        context,
        "La edad del estudiante debe estar entre 5 y 18 años",
      );
      return;
    }
    if (nombresEstudianteController.text.isEmpty ||
        apellidosEstudianteController.text.isEmpty ||
        nombresRepresanteController.text.isEmpty ||
        edadTexto.isEmpty ||
        selectCursoId == null) {
      Customizarsnackbar.mostrarError(context, "Por favor complete los campos");
      return;
    }
    EstudiantesModel nuevoEstudiante = EstudiantesModel(
        id: widget.estudiantes.id,
        nombresEstudiante: nombresEstudianteController.text,
        apellidosEstudiante: apellidosEstudianteController.text,
        edadEstudiante: edadEstudiante,
        nombresRepresentante: nombresRepresanteController.text,
        fkCursos: selectCursoId!);
    try {
      bool exito = await estudiantecontroller.actualizarEstudiantes(
          nuevoEstudiante.id!, nuevoEstudiante);
      if (exito) {
        Customizarsnackbar.mostrarExito(
            context, 'Estudiante actualizado Correctamente');
        Navigator.pop(context);
      } else {
        Customizarsnackbar.mostrarError(
            context, "Error al actualizar al estudiante");
      }
    } catch (e) {
      Customizarsnackbar.mostrarError(
          context, "Error inesperado al actualizar al estudiante");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // Deshabilita el botón de retroceso
        centerTitle: true,
        backgroundColor: Color(0xFF094263), // Color 2
        title: Text(
          'Actualizar Estudiantes',
          style: GoogleFonts.gabarito(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: nombresEstudianteController,
                decoration: InputDecoration(
                  labelText: 'Nombres del Estudiante',
                  labelStyle: TextStyle(color: Color(0xFF094263)), // Color 2
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person_rounded,
                      color: Color(0xFF094263)), // Color 2
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: apellidosEstudianteController,
                decoration: InputDecoration(
                  labelText: 'Apellidos del Estudiante',
                  labelStyle: TextStyle(color: Color(0xFF094263)), // Color 2
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person_rounded,
                      color: Color(0xFF094263)), // Color 2
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nombresRepresanteController,
                decoration: InputDecoration(
                  labelText: 'Nombres del Representante',
                  labelStyle: TextStyle(color: Color(0xFF094263)), // Color 2
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person_rounded,
                      color: Color(0xFF094263)), // Color 2
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Edad del Estudiante:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: edadEstudianteController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Ej: 10 años',
                        hintStyle:
                            TextStyle(color: Color(0xFF094263)), // Color 2
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.cake_rounded,
                            color: Color(0xFF094263)), // Color 2
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    'Curso del Estudiante:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        hintText: 'Seleccione un curso',
                        hintStyle:
                            TextStyle(color: Color(0xFF094263)), // Color 2
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.menu_book_rounded,
                            color: Color(0xFF094263)), // Color 2
                      ),
                      value: selectCursoId,
                      items: listaCursos.map((Cursosmodel cursos) {
                        return DropdownMenuItem<int>(
                          value: cursos.id,
                          child: Text(
                            cursos.curso,
                            style:
                                TextStyle(color: Color(0xFF094263)), // Color 2
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectCursoId = value;
                        });
                      },
                      menuMaxHeight: 200,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF094263), // Azul oscuro
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: actualizar,
                  icon: const Icon(Icons.save,
                      color: Colors.white), // Ícono de guardar
                  label: const Text(
                    'Registrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
