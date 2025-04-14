import 'package:notas_estudiantes/Asignaturas/view/AsignaturaEdit.dart';
import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Asignaturastable extends StatefulWidget {
  const Asignaturastable({super.key});

  @override
  State<Asignaturastable> createState() => _AsignaturastableState();
}

class _AsignaturastableState extends State<Asignaturastable> {
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
              hintText: "Buscar Asignatura...",
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
          : controller.asignaturasFiltradas.isEmpty
              ? Center(child: Text("No hay Asignaturas disponibles"))
              : Column(
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Text(
                              'Asignaturas',
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
                                    .obtenerAsignaturasPaginadas()
                                    .length,
                                itemBuilder: (context, index) {
                                  final asignatura = controller
                                      .obtenerAsignaturasPaginadas()[index];
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
                                      leading: Icon(Icons.book,
                                          size: 40,
                                          color: Color(0xFF094263)), // Color 2
                                      title: Text(
                                        asignatura.nombreAsignatura,
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
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .end, // Alinea los elementos a la derecha

                                                children: [
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Asignaturaedit(
                                                                      asignaturas:
                                                                          asignatura))).then(
                                                          (_) => controller
                                                              .obtenerAsignaturas());
                                                      // Acción de edición
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
                                                              context,
                                                              asignatura);
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
                                }),
                            controller
                                .construirBotonesPaginacion(), // 👈 Aquí va la paginación
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
      // Botón flotante con ícono de agregar
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
              context, 'asignaturas'); // Redirige al formulario de cursos
        },
        backgroundColor: Color(0xFF094263),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
