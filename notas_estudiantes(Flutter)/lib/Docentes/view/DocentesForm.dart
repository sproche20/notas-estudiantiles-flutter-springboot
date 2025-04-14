import 'package:notas_estudiantes/Docentes/controller/DocenteController.dart';
import 'package:notas_estudiantes/Docentes/functions/funcionesDocente.dart';
import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Docentesform extends StatefulWidget {
  const Docentesform({super.key});

  @override
  State<Docentesform> createState() => _DocentesformState();
}

class _DocentesformState extends State<Docentesform> {
  late Funcionesdocente controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Funcionesdocente(mounted, setState);
    controller.init(context, setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF094263), // Color 2
        title: Text(
          'Registrar Docente',
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
                controller: controller.nombresDocenteController,
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
                controller: controller.apellidosDocenteController,
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
                controller: controller.especialidadDocenteController,
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
                value: controller.selectedAsignaturaId,
                items: controller.listaAsignaturas
                    .map((Asignaturamodel asignaturas) {
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
                    controller.selectedAsignaturaId = value;
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
                  onPressed: controller.guardarDocente,
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
