import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Cursostable extends StatefulWidget {
  const Cursostable({super.key});

  @override
  State<Cursostable> createState() => _CursostableState();
}

class _CursostableState extends State<Cursostable> {
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
                                                children: [
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Cursosedit(
                                                                      cursos:
                                                                          curso))).then(
                                                          (_) => controller
                                                              .obtenerCursos());
                                                    },
                                                    icon: Icon(Icons.edit,
                                                        color: Colors.white),
                                                    label: Text("Editar",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: Color(
                                                          0xFF094263), // Azul oscuro
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      controller
                                                          .mostrarConfirmacionEliminar(
                                                              context, curso);
                                                    },
                                                    icon: Icon(Icons.delete,
                                                        color: Colors.white),
                                                    label: Text("Eliminar",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
              context, 'cursos'); // Redirige al formulario de cursos
        },
        backgroundColor: Color(0xFF094263),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
