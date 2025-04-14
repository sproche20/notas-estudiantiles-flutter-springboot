import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Filtroporcurso extends StatefulWidget {
  const Filtroporcurso({super.key});

  @override
  State<Filtroporcurso> createState() => _FiltroporcursoState();
}

class _FiltroporcursoState extends State<Filtroporcurso> {
  List<Calfinalmodel> calificacionesFiltradas = [];
  late Funcionescurso controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Funcionescurso(mounted, setState);
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
              hintText: "Buscar Curso...",
              hintStyle: TextStyle(color: Colors.grey[600]),
              prefixIcon: Icon(Icons.search, color: Colors.blue),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 15),
            ),
            style: TextStyle(color: Colors.black),
            cursorColor: Colors.blue,
          ),
        ),
      ),
      body: controller.isLoading
          ? Center(child: CircularProgressIndicator())
          : controller.cursosFiltrados.isEmpty
              ? Center(child: Text("No hay Cursos disponibles"))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                'Cursos',
                                style: GoogleFonts.gabarito(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3,
                                  color: Color(0xFF094263), // Color 2
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFFE3F2FD), // Azul claro suave
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color:
                                          Color(0xFF1976D2)), // Azul más fuerte
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.info_outline,
                                        color: Color(0xFF1976D2), size: 30),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Para ver las notas finales de los estudiantes, pulsa el botón "Notas finales" en el curso correspondiente.',
                                        style: GoogleFonts.sofiaSans(
                                          fontSize: 16,
                                          color: Color(0xFF0D47A1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    controller.obtenerCursosPaginados().length,
                                itemBuilder: (context, index) {
                                  final curso = controller
                                      .obtenerCursosPaginados()[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xFF094263),
                                          width: 2), // Color 2
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white, // Color 1
                                    ),
                                    child: ExpansionTile(
                                      leading: Icon(Icons.school,
                                          size: 40,
                                          color: Color(0xFF094263)), // Color 2
                                      title: Text(
                                        curso.curso,
                                        style: GoogleFonts.gabarito(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 3,
                                          color: Color(0xFF094263), // Color 2
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Tutor: ${controller.primerNombre(curso.nombreDocente)} ${controller.primerApellido(curso.apellidoDocente)}',
                                        style:
                                            GoogleFonts.sofiaSansSemiCondensed(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 3,
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
                                                'Tutor: ${controller.primerNombre(curso.nombreDocente)} ${controller.primerApellido(curso.apellidoDocente)}',
                                                style: TextStyle(
                                                    color: Color(0xFF094263)),
                                              ),
                                              Text(
                                                'Curso: ${curso.curso}',
                                                style: TextStyle(
                                                    color: Color(0xFF094263)),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .end, // Alinea los elementos a la derecha
                                                children: [
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      // Obtener el cursoId
                                                      int cursoId = curso
                                                          .id!; // O la propiedad que contiene el ID del curso

                                                      // Navegar a la pantalla de calificaciones finales, pasando el cursoId
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Calfinaltable(
                                                                  cursoId:
                                                                      cursoId),
                                                        ),
                                                      );
                                                    },
                                                    icon: Icon(Icons.edit,
                                                        color: Colors.white),
                                                    label: Text("Notas finales",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: Color(
                                                          0xFF094263), // Azul oscuro
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 10),
                              controller
                                  .construirBotonesPaginacion(), // 👈 Aquí va la paginación
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
// Botón flotante con ícono de agregar
      // Botón flotante con ícono de agregar
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
              context, 'notasAsignatura'); // Redirige al formulario de cursos
        },
        backgroundColor: Color(0xFF094263),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
