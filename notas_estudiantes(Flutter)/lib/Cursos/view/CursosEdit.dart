import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Cursosedit extends StatefulWidget {
  final Cursosmodel cursos;
  const Cursosedit({super.key, required this.cursos});

  @override
  State<Cursosedit> createState() => _CursoseditState();
}

class _CursoseditState extends State<Cursosedit> {
  final TextEditingController nombreCursoController = TextEditingController();
  int? selectDocenteId;
  List<Docentemodel> listarDocentes = [];
  final Cursocontroller cursocontroller = Cursocontroller();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cargarDocentes();
    nombreCursoController.text = widget.cursos.curso;
    selectDocenteId = widget.cursos.fkDocente;
  }

  Future<void> _cargarDocentes() async {
    try {
      List<Docentemodel> docentes = await cursocontroller.obtenerDocente();
      setState(() {
        listarDocentes = docentes;
      });
    } catch (e) {
      Customizarsnackbar.mostrarError(context, 'Error al cargar docentes.');
      print("Error al cargar Docentes: $e");
    }
  }

  Future<void> actualizarCurso() async {
    if (nombreCursoController.text.isEmpty || selectDocenteId == null) {
      Customizarsnackbar.mostrarError(context, 'Por favor complete los campos');
      return;
    }
    Cursosmodel nuevoCurso = Cursosmodel(
        id: widget.cursos.id,
        curso: nombreCursoController.text,
        fkDocente: selectDocenteId!);
    try {
      bool exito =
          await cursocontroller.actualizarCurso(widget.cursos.id!, nuevoCurso);
      if (exito) {
        Customizarsnackbar.mostrarExito(
            context, "Asignatura Actualizada Correctamente");
        Navigator.pop(context);
      } else {
        Customizarsnackbar.mostrarError(
            context, "Error al actualizar el curso");
      }
    } catch (e) {
      Customizarsnackbar.mostrarError(
          context, "Error inesperado al actualizar el curso");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF094263), // Color 2
        title: Text(
          'Actualizar Curso',
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
                controller: nombreCursoController,
                decoration: InputDecoration(
                  labelText: 'Nombre Curso',
                  labelStyle: TextStyle(color: Color(0xFF094263)), // Color 2
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.book,
                      color: Color(0xFF094263)), // Color 2
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Tutor',
                  labelStyle: TextStyle(color: Color(0xFF094263)), // Color 2
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person_rounded,
                      color: Color(0xFF094263)), // Color 2
                ),
                value: selectDocenteId,
                items: listarDocentes.map((Docentemodel docente) {
                  return DropdownMenuItem<int>(
                    value: docente.id,
                    child: Text(
                      docente.nombresDocente,
                      style: TextStyle(color: Color(0xFF094263)), // Color 2
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectDocenteId = value;
                  });
                },
                menuMaxHeight: 200, // Limita la altura máxima del menú
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
                  onPressed: actualizarCurso,
                  icon: const Icon(Icons.save,
                      color: Colors.white), // Ícono de guardar
                  label: const Text(
                    'Guardar',
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
