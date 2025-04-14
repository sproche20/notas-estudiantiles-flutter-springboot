import 'package:notas_estudiantes/Docentes/functions/funcionesDocente.dart';
import 'package:notas_estudiantes/Docentes/view/DocentesEdit.dart';
import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Docentetable extends StatefulWidget {
  const Docentetable({super.key});

  @override
  State<Docentetable> createState() => _DocentetableState();
}

class _DocentetableState extends State<Docentetable> {
  late Funcionesdocente controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Funcionesdocente(mounted, setState);
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
              hintText: "Buscar Docente...",
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
          : controller.docentesFiltrados.isEmpty
              ? Center(child: Text("No hay Docentes disponibles"))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                'Docentes',
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
                                    .obtenerDocentesPaginados()
                                    .length,
                                itemBuilder: (context, index) {
                                  final docente = controller
                                      .obtenerDocentesPaginados()[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xFF094263),
                                          width: 2), // Color 2
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors
                                          .white, // Color 1 (fondo de cada tarjeta)
                                    ),
                                    child: ExpansionTile(
                                      leading: Icon(Icons.person_rounded,
                                          size: 40,
                                          color: Color(0xFF094263)), // Color 2
                                      title: Text(
                                        '${controller.primerNombre(docente.nombresDocente)} ${controller.primerApellido(docente.apellidosDocente)}',
                                        style: GoogleFonts.gabarito(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          color: Color(0xFF094263), // Color 2
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Asignatura: ${docente.nombreAsignatura}',
                                        style:
                                            GoogleFonts.sofiaSansSemiCondensed(
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
                                                'Nombres completos: ${docente.nombresDocente ?? "No disponible"}',
                                                style: TextStyle(
                                                    color: Color(0xFF094263)),
                                              ),
                                              Text(
                                                'Apellidos completos: ${docente.apellidosDocente ?? "No disponible"}',
                                                style: TextStyle(
                                                    color: Color(0xFF094263)),
                                              ),
                                              Text(
                                                'Especialidad: ${docente.especialidadDocente ?? "No disponible"}',
                                                style: TextStyle(
                                                    color: Color(0xFF094263)),
                                              ),
                                              Text(
                                                'Asignatura encargada: ${docente.nombreAsignatura ?? "No disponible"}',
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
                                                                  Docentesedit(
                                                                      docentes:
                                                                          docente))).then(
                                                          (_) {
                                                        controller
                                                            .obtenerDocentes();
                                                      });
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
                                                      if (docente.id != null) {
                                                        controller
                                                            .eliminarDocentes(
                                                                context,
                                                                docente.id!);
                                                      }
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
              context, 'docentes'); // Redirige al formulario de cursos
        },
        backgroundColor: Color(0xFF094263),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
