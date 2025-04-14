import 'package:notas_estudiantes/Estudiantes/functions/funcionesEstudiante.dart';
import 'package:notas_estudiantes/Estudiantes/view/EstudiantesEdit.dart';
import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Estudiantestable extends StatefulWidget {
  const Estudiantestable({super.key});

  @override
  State<Estudiantestable> createState() => _EstudiantestableState();
}

class _EstudiantestableState extends State<Estudiantestable> {
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
        automaticallyImplyLeading: false, // Deshabilita el botón de retroceso
        centerTitle: true,
        backgroundColor: Color(0xFF094263), // Color 2
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Color 1
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller.buscarController,
            decoration: InputDecoration(
              hintText: "Buscar estudiante...",
              hintStyle: TextStyle(color: Color(0xFFB3B2AE)), // Color 3
              prefixIcon:
                  Icon(Icons.search, color: Color(0xFF094263)), // Color 2
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 15),
            ),
            style: TextStyle(color: Colors.black),
            cursorColor: Color(0xFF094263),
          ),
        ),
      ),
      body: controller.isLoading
          ? Center(child: CircularProgressIndicator())
          : controller.estudiantesFiltrados.isEmpty
              ? Center(child: Text("No hay Estudiantes disponibles"))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                'Estudiantes',
                                style: GoogleFonts.gabarito(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3,
                                  color: Color(0xFF094263), // Color 2
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: controller
                                      .obtenerEstudiantesPaginados()
                                      .length,
                                  itemBuilder: (context, index) {
                                    final estudiante = controller
                                        .obtenerEstudiantesPaginados()[index];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 10.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xFF094263),
                                            width: 2), // Color 2
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors
                                            .white, // Color 1 (fondo de cada tarjeta)
                                      ),
                                      child: ExpansionTile(
                                        leading: Icon(Icons.person_rounded,
                                            size: 40,
                                            color:
                                                Color(0xFF094263)), // Color 2
                                        title: Text(
                                          '${controller.primerNombre(estudiante.nombresEstudiante)} ${controller.primerApellido(estudiante.apellidosEstudiante)}',
                                          style: GoogleFonts.gabarito(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                            color: Color(0xFF094263), // Color 2
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Curso:${estudiante.curso}',
                                          style: GoogleFonts
                                              .sofiaSansSemiCondensed(
                                            fontSize: 14,
                                            letterSpacing: 1,
                                            color: Color(
                                                0xFF4D6370), // Gris azulado medio
                                          ),
                                        ),
                                        children: [
                                          ListTile(
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Divider(
                                                    color: Color(
                                                        0xFF094263)), // Color 2
                                                Text(
                                                  'Nombres Completos:${estudiante.nombresEstudiante ?? " No disponible"}',
                                                  style: TextStyle(
                                                      color: Color(0xFF094263)),
                                                ),
                                                Text(
                                                  'Apellidos Completos:${estudiante.apellidosEstudiante ?? " No disponible"}',
                                                  style: TextStyle(
                                                      color: Color(0xFF094263)),
                                                ),
                                                Text(
                                                  'Edad del estudiante:${estudiante.edadEstudiante ?? " No disponible"}',
                                                  style: TextStyle(
                                                      color: Color(0xFF094263)),
                                                ),
                                                Text(
                                                  'Nombre del Representante:${estudiante.nombresRepresentante ?? " No disponible"}',
                                                  style: TextStyle(
                                                      color: Color(0xFF094263)),
                                                ),
                                                Text(
                                                  'Curso del Estudiante:${estudiante.curso ?? " No disponible"}',
                                                  style: TextStyle(
                                                      color: Color(0xFF094263)),
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    ElevatedButton.icon(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    Estudiantesedit(
                                                                        estudiantes:
                                                                            estudiante))).then(
                                                            (_) {
                                                          controller
                                                              .obtenerEstudiantes();
                                                        });
                                                      },
                                                      icon: Icon(Icons.edit,
                                                          color: Colors.white),
                                                      label: Text("Editar",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: Color(
                                                            0xFF094263), // Azul oscuro
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    ElevatedButton.icon(
                                                      onPressed: () {
                                                        if (estudiante.id !=
                                                            null) {
                                                          controller
                                                              .eliminarEstudiante(
                                                                  context,
                                                                  estudiante
                                                                      .id!);
                                                        }
                                                      },
                                                      icon: Icon(Icons.delete,
                                                          color: Colors.white),
                                                      label: Text("Eliminar",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: Color(
                                                            0xFFB3B2AE), // Gris claro
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
                    controller.construirBotonesPaginacion(),
                  ],
                ),
      // Botón flotante con ícono de agregar
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
              context, 'estudiantes'); // Redirige al formulario de cursos
        },
        backgroundColor: Color(0xFF094263),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
