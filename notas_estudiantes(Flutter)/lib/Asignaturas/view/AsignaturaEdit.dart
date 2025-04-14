import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Asignaturaedit extends StatefulWidget {
  final Asignaturamodel asignaturas;
  const Asignaturaedit({super.key, required this.asignaturas});

  @override
  State<Asignaturaedit> createState() => _AsignaturaeditState();
}

class _AsignaturaeditState extends State<Asignaturaedit> {
  late Funcionesasignatura controller;

  final Asignaturacontroller asignaturaController = Asignaturacontroller();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Funcionesasignatura(mounted, setState);
    controller.init(context, setState);
    controller.NombreAsignatura.text = widget.asignaturas.nombreAsignatura;
  }

  Future<void> _actualizar() async {
    if (widget.asignaturas.id == null) {
      Customizarsnackbar.mostrarError(
          context, "Error: la asignatura no tiene un ID válido'");
      return;
    }
    if (controller.NombreAsignatura.text.isEmpty) {
      Customizarsnackbar.mostrarError(context, "Por Favor complete los campos");
      return;
    }
    Asignaturamodel nuevaAsignatura = Asignaturamodel(
        id: widget.asignaturas.id,
        nombreAsignatura: controller.NombreAsignatura.text);
    try {
      bool exito = await asignaturaController.actualizarAsignatura(
          widget.asignaturas.id!, nuevaAsignatura);
      if (exito) {
        Customizarsnackbar.mostrarExito(
            context, "Asignatura Actualizada Correctamente");
        Navigator.pop(context);
      } else {
        Customizarsnackbar.mostrarError(
            context, "Error al actualizar Asignatura");
      }
    } catch (e) {
      Customizarsnackbar.mostrarError(
          context, "Error inesperado al actualizar la asignatura");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF094263), // Color 2
        title: Text(
          'Actualizar Asignatura',
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
                    prefixIcon: const Icon(Icons.menu_book_rounded,
                        color: Color(0xFF094263))),
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
                  onPressed: _actualizar,
                  child: const Text(
                    'Actualizar',
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
