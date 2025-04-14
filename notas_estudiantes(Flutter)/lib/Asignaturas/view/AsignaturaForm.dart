import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Asignaturaform extends StatefulWidget {
  const Asignaturaform({super.key});

  @override
  State<Asignaturaform> createState() => _AsignaturaformState();
}

class _AsignaturaformState extends State<Asignaturaform> {
  late Funcionesasignatura controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Funcionesasignatura(mounted, setState);
    controller.init(context, setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF094263), // Color 2
        title: Text(
          'Registrar Asignatura',
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
                controller: controller.NombreAsignatura,
                decoration: InputDecoration(
                    labelText: 'Nombre Asignatura',
                    labelStyle: TextStyle(color: Color(0xFF094263)), // Color 2

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon:
                        const Icon(Icons.book, color: Color(0xFF094263))),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF094263), // Color 2
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: controller.guardarAsignatura,
                  child: const Text(
                    'Registrar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
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
