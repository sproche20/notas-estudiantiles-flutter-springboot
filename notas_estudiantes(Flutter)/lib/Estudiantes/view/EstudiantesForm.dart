import 'package:notas_estudiantes/Estudiantes/functions/funcionesEstudiante.dart';
import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Estudiantesform extends StatefulWidget {
  const Estudiantesform({super.key});

  @override
  State<Estudiantesform> createState() => _EstudiantesformState();
}

class _EstudiantesformState extends State<Estudiantesform> {
  late Funcionesestudiante controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Funcionesestudiante(mounted, setState);
    controller.init(context, setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // Deshabilita el botón de retroceso
        centerTitle: true,
        backgroundColor: Color(0xFF094263), // Color 2
        title: Text(
          'Registrar Estudiantes',
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
                controller: controller.nombresEstudianteController,
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
                controller: controller.apellidosEstudianteController,
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
                controller: controller.nombresRepresanteController,
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
                      controller: controller.edadEstudianteController,
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
                      value: controller.selectCursoId,
                      items: controller.listaCursos.map((Cursosmodel cursos) {
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
                          controller.selectCursoId = value;
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
                  onPressed: controller.registrarEstudiante,
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
