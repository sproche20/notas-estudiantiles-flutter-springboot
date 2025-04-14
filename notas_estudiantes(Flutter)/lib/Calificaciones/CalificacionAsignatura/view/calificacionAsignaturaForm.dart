import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Calificacionasignaturaform extends StatefulWidget {
  const Calificacionasignaturaform({super.key});

  @override
  State<Calificacionasignaturaform> createState() =>
      _CalificacionasignaturaformState();
}

class _CalificacionasignaturaformState
    extends State<Calificacionasignaturaform> {
  final Calificacionasigformcontrolador controller =
      Calificacionasigformcontrolador();

  @override
  void initState() {
    super.initState();
    controller.init(context, setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Registrar Notas Asignatura",
          style: GoogleFonts.gabarito(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF094263), // Color 2
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Curso del estudiante:',
                    style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      hintText: 'Seleccione un curso',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.menu_book_rounded,
                          color: Color(0xFF094263)), // Color 2
                    ),
                    value: controller.selectedCursoId,
                    items: controller.listaCursos.map((curso) {
                      return DropdownMenuItem<int>(
                        value: curso.id,
                        child: Text(curso.curso,
                            style:
                                TextStyle(color: Color(0xFF094263))), // Color 2
                      );
                    }).toList(),
                    onChanged: (value) => controller.onCursoSeleccionado(value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Estudiante',
                labelStyle: TextStyle(color: Color(0xFF094263)), // Color 2
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person_rounded,
                    color: Color(0xFF094263)), // Color 2
              ),
              value: controller.selectedEstudianteId,
              items: controller.listaEstudiantes.map((est) {
                return DropdownMenuItem<int>(
                  value: est.id,
                  child: Text(est.nombresEstudiante,
                      style: TextStyle(color: Color(0xFF094263))), // Color 2
                );
              }).toList(),
              onChanged: controller.puedeSeleccionarEstudiante()
                  ? (value) => controller.onEstudianteSeleccionado(value)
                  : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Asignatura',
                labelStyle: TextStyle(color: Color(0xFF094263)), // Color 2
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.book_rounded,
                    color: Color(0xFF094263)), // Color 2
              ),
              value: controller.selectedAsignaturaId,
              items: controller.listaAsignaturas.map((asig) {
                return DropdownMenuItem<int>(
                  value: asig.id,
                  child: Text(asig.nombreAsignatura,
                      style: TextStyle(color: Color(0xFF094263))), // Color 2
                );
              }).toList(),
              onChanged: (value) => controller.onAsignaturaSeleccionada(value),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              itemCount: controller.notasList.length,
              itemBuilder: (context, index) {
                final nota = controller.notasList[index];
                return Card(
                  child: ListTile(
                    title: TextField(
                      decoration: InputDecoration(
                          labelText:
                              "Nota de ${controller.obtenerNombreAsignatura(nota.fkAsignatura)}",
                          labelStyle:
                              TextStyle(color: Color(0xFF094263))), // Color 2
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          controller.actualizarNota(index, value),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.agregarOtraAsignatura,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF094263), // Color 2
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Agregar otra asignatura',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF094263), // Color 2
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: controller.guardarCalificacionAsignatura,
                icon: const Icon(Icons.save, color: Colors.white),
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
    );
  }
}
