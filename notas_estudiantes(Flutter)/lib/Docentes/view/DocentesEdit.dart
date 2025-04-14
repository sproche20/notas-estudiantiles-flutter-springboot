import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Docentesedit extends StatefulWidget {
  final Docentemodel docentes;
  const Docentesedit({super.key, required this.docentes});

  @override
  State<Docentesedit> createState() => _DocenteseditState();
}

class _DocenteseditState extends State<Docentesedit> {
  final TextEditingController nombresDocenteController =
      TextEditingController();
  final TextEditingController apellidosDocenteController =
      TextEditingController();
  final TextEditingController especialidadDocenteController =
      TextEditingController();
  int? selectedAsignaturaId;
  List<Asignaturamodel> listaAsignaturas = [];
  final Docentecontroller docentecontroller = Docentecontroller();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cargarAsignaturas();

    nombresDocenteController.text = widget.docentes.nombresDocente;
    apellidosDocenteController.text = widget.docentes.apellidosDocente;
    especialidadDocenteController.text = widget.docentes.especialidadDocente;
    selectedAsignaturaId = widget.docentes.fkAsignatura;
  }

  Future<void> _cargarAsignaturas() async {
    try {
      List<Asignaturamodel> asignaturas =
          await docentecontroller.obtenerasignaturas();
      setState(() {
        listaAsignaturas = asignaturas;
      });
    } catch (e) {
      print("Error al cargar Asignaturas: $e");
    }
  }

  Future<void> actualizar() async {
    if (nombresDocenteController.text.isEmpty ||
        apellidosDocenteController.text.isEmpty ||
        especialidadDocenteController.text.isEmpty ||
        selectedAsignaturaId == null) {
      Customizarsnackbar.mostrarError(context, "Por favor complete los campos");
      return;
    }
    Docentemodel nuevoDocente = Docentemodel(
        id: widget.docentes.id,
        nombresDocente: nombresDocenteController.text,
        apellidosDocente: apellidosDocenteController.text,
        especialidadDocente: especialidadDocenteController.text,
        fkAsignatura: selectedAsignaturaId!);
    try {
      bool exito = await docentecontroller.actualizarDocente(
          nuevoDocente.id!, nuevoDocente);
      if (exito) {
        Customizarsnackbar.mostrarExito(
            context, 'Docente actualizado Correctamente');
        Navigator.pushNamed(context, 'docentesTable'); // Cerrar el formulario
      } else {
        Customizarsnackbar.mostrarError(
            context, "Error al actualizar el docente");
      }
    } catch (e) {
      Customizarsnackbar.mostrarError(
          context, "Error inesperado al actualizar al docente");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF094263), // Color 2
        title: Text(
          'Actualizar Docente',
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
                controller: nombresDocenteController,
                decoration: InputDecoration(
                  labelText: 'Nombres del Docente',
                  labelStyle: TextStyle(color: Color(0xFF094263)), // Color 2
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person_rounded,
                      color: Color(0xFF094263)), // Color 2
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: apellidosDocenteController,
                decoration: InputDecoration(
                  labelText: 'Apellidos del Docente',
                  labelStyle: TextStyle(color: Color(0xFF094263)), // Color 2
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person_rounded,
                      color: Color(0xFF094263)), // Color 2
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: especialidadDocenteController,
                decoration: InputDecoration(
                  labelText: 'Especialidad del Docente',
                  labelStyle: TextStyle(color: Color(0xFF094263)), // Color 2
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.school_outlined,
                      color: Color(0xFF094263)), // Color 2
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Asignatura encargado(a)',
                  labelStyle: TextStyle(color: Color(0xFF094263)), // Color 2
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.menu_book_rounded,
                      color: Color(0xFF094263)), // Color 2
                ),
                value: selectedAsignaturaId,
                items: listaAsignaturas.map((Asignaturamodel asignaturas) {
                  return DropdownMenuItem<int>(
                    value: asignaturas.id,
                    child: Text(
                      asignaturas.nombreAsignatura,
                      style: TextStyle(color: Color(0xFF094263)), // Color 2
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAsignaturaId = value;
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
                    backgroundColor: Color(0xFF094263), // Color 2
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
