import 'package:notas_estudiantes/Calificaciones/CalificacionAsignatura/view/calificacionAsignaturaEdit.dart';
import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Notasasignaturatable extends StatefulWidget {
  final int estudianteId;

  const Notasasignaturatable({super.key, required this.estudianteId});

  @override
  State<Notasasignaturatable> createState() => _NotasasignaturatableState();
}

class _NotasasignaturatableState extends State<Notasasignaturatable> {
  late Future<List<CalPorAsigModel>> calificacionesFuture;
  final Calporasigcontroller _calporasigcontroller = Calporasigcontroller();

  @override
  void initState() {
    super.initState();
    calificacionesFuture = Calporasigcontroller()
        .obtenerCalificacionesPorEstudiante(widget.estudianteId);
  }

  Future<void> _eliminar(int id) async {
    bool? confirmacion = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Eliminar Notas"),
              content:
                  Text("¿Estás seguro de que deseas eliminar estos datos?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text("Eliminar", style: TextStyle(color: Colors.red)),
                ),
              ],
            ));
    if (confirmacion == true) {
      try {
        // Llamar al controlador para eliminar el cambio
        await _calporasigcontroller.eliminarCalificaciones(id);
        Navigator.pushNamed(context, 'filtroCurso'); // Cerrar el formulario

        Customizarsnackbar.mostrarExito(context, "notas eliminadas con éxito");
        Navigator.pushReplacementNamed(context, 'calificacionFinalTable');
      } catch (e) {
        Customizarsnackbar.mostrarError(
            context, "Error al eliminar la asignatura");
        print("Error al eliminar el historial de cambio: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CalPorAsigModel>>(
      future: calificacionesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay calificaciones disponibles.'));
        }

        var calificaciones = snapshot.data!;

        return ListView.builder(
          itemCount: calificaciones.length,
          itemBuilder: (context, index) {
            var calificacion = calificaciones[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(color: Color(0xFF094263), width: 2),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Estudiante: ${calificacion.nombreEstudiante ?? 'Desconocido'}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF094263),
                      ),
                    ),
                    Text(
                      "Curso: ${calificacion.Curso ?? 'Desconocido'}",
                      style: TextStyle(color: Color(0xFF4D6370)),
                    ),
                    SizedBox(height: 8),
                    SizedBox(height: 16),
                    // Mueve la tabla a la parte inferior de la columna
                    Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(
                              label: Text(
                                'Asignatura',
                                style: TextStyle(color: Color(0xFF094263)),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Nota',
                                style: TextStyle(color: Color(0xFF094263)),
                              ),
                            ),
                          ],
                          rows: calificacion.notas.map((nota) {
                            return DataRow(cells: [
                              DataCell(
                                Text(
                                  nota.nombreAsignatura ?? 'Sin nombre',
                                  style: TextStyle(color: Color(0xFF4D6370)),
                                ),
                              ),
                              DataCell(
                                Text(nota.nota.toString(),
                                    style: TextStyle(color: Color(0xFF4D6370))),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Botones al final de la columna
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final calificacion = calificaciones[index];
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Calificacionasignaturaedit(
                                  calificacionAsignatura: calificacion,
                                ),
                              ),
                            );

                            // Si result no es null, significa que el estudiante fue editado
                            if (result != null) {
                              setState(() {
                                // Aquí actualizas el calificación en la lista
                                calificaciones[index] =
                                    result; // Se actualiza la calificación del estudiante
                              });
                            }
                          },
                          icon: Icon(Icons.edit, color: Colors.white),
                          label: Text("Editar",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF094263),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () => _eliminar(calificacion.id!),
                          icon: Icon(Icons.delete, color: Colors.white),
                          label: Text("Eliminar",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFB3B2AE),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
