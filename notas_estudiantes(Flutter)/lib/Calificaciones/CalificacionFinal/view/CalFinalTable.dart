import 'package:notas_estudiantes/Calificaciones/CalificacionFinal/functions/funcionesCalFinal.dart';
import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Calfinaltable extends StatefulWidget {
  final int cursoId;
  const Calfinaltable({super.key, required this.cursoId});
  @override
  State<Calfinaltable> createState() => _CalfinaltableState();
}

class _CalfinaltableState extends State<Calfinaltable> {
  late Funcionescalfinal controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Funcionescalfinal(mounted, setState);
    controller.init(context, setState);
    obtenerNotasFinales();
  }

  Future<void> obtenerNotasFinales() async {
    try {
      // Obtén las calificaciones sin filtro
      List<Calfinalmodel> calificacionFinal =
          await controller.calfinalcontroller.obtenerCalificaciones();
      //filtrar las calificaciones por curso id
      calificacionFinal = calificacionFinal.where((calificacion) {
        return calificacion.fkCurso == widget.cursoId;
      }).toList();
      if (!mounted) return;
      await Future.wait(calificacionFinal.map((calficacion) async {
        final estudiante = await controller.calfinalcontroller
            .obtenerNombreEstudiantes(calficacion.fkEstudiante);
        if (estudiante != null) {
          calficacion.nombreEstudiante = estudiante.nombresEstudiante;
        }
      }));
      if (!mounted) return; // ✅ Verificación antes de actualizar el estado
      setState(() {
        controller.calificacionFinal = calificacionFinal;
        controller.calificacionFinalFiltrada = calificacionFinal;
        controller.isLoading = false;
      });
    } catch (e) {
      print("Error al obtener Estudiantes:$e");
      if (!mounted) return;
      setState(() {
        controller.isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // Deshabilita el botón de retroceso

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
              hintText: "Buscar por Estudiante...",
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
          : controller.calificacionFinalFiltrada.isEmpty
              ? Center(child: Text("No hay notas  disponibles"))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                'Notas finales',
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
                                      .obtenerCalificacionPaginada()
                                      .length,
                                  itemBuilder: (context, index) {
                                    final calificaciones = controller
                                        .obtenerCalificacionPaginada()[index];
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
                                          '${controller.primerNombre(calificaciones.nombreEstudiante)} ${controller.primerApellido(calificaciones.apellidoEstudiante)}',
                                          style: GoogleFonts.gabarito(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                            color: Color(0xFF094263), // Color 2
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Calificación Final: ${calificaciones.notaFinal}',
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
                                                    color: Color(0xFF094263)),
                                                // Agregar el botón para ir a la nueva pantalla
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .end, // Alinea los elementos a la derecha
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return WillPopScope(
                                                              onWillPop:
                                                                  () async {
                                                                // Permite que el botón de retroceso cierre el diálogo
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                return Future.value(
                                                                    true); // Indica que el retroceso es permitido
                                                              },
                                                              child: Dialog(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12.0), // Bordes redondeados
                                                                ),
                                                                child:
                                                                    Container(
                                                                  width:
                                                                      400, // Ancho específico
                                                                  height:
                                                                      500, // Alto específico
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly, // Centra la columna
                                                                    children: [
                                                                      // Contenedor estilizado para "Notas del estudiante"
                                                                      Container(
                                                                        width: double
                                                                            .infinity,
                                                                        padding:
                                                                            EdgeInsets.all(16.0),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Color(0xFF094263), // Fondo azul
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0), // Bordes redondeados
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "Notas del estudiante",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white, // Texto blanco
                                                                            fontSize:
                                                                                18, // Tamaño de fuente grande
                                                                            fontWeight:
                                                                                FontWeight.bold, // Negrita
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Center(
                                                                          // Centra el widget de la tabla
                                                                          child:
                                                                              Notasasignaturatable(
                                                                            estudianteId:
                                                                                calificaciones.fkEstudiante,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      // Botón para cerrar el diálogo
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop(); // Cierra el diálogo
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Cerrar',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                Color(0xFF094263), // Color del botón
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ).then((value) {
                                                          // Esto se ejecutará después de cerrar el diálogo
                                                        });
                                                      },
                                                      child: Text(
                                                          'Ver Notas por Asignatura'),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: Color(
                                                            0xFF094263), // Color de fondo
                                                        foregroundColor: Colors
                                                            .white, // Color del texto
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
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
    );
  }
}
