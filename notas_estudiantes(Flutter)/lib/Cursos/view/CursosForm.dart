import 'package:notas_estudiantes/Cursos/functions/funcionesCurso.dart';
import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Cursosform extends StatefulWidget {
  const Cursosform({super.key});

  @override
  State<Cursosform> createState() => _CursosformState();
}

class _CursosformState extends State<Cursosform> {
  late Funcionescurso controller;
  @override
  void initState() {
    super.initState();
    controller = Funcionescurso(mounted, setState);
    controller.init(context, setState);
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // Deshabilita el botón de retroceso
        centerTitle: true,
        backgroundColor: Color(0xFF094263), // Color 2
        title: Text(
          'Crear Curso',
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
                controller: controller.nombreCursoController,
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
                value: controller.selectDocenteId,
                items: controller.listarDocentes.map((Docentemodel docente) {
                  return DropdownMenuItem<int>(
                    value: docente.id,
                    child: Text(
                      '${controller.primerNombre(docente.nombresDocente)} ${controller.primerApellido(docente.apellidosDocente)}',
                      style: TextStyle(color: Color(0xFF094263)), // Color 2
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    controller.selectDocenteId = value;
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
                  onPressed: controller.guardarCurso,
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
