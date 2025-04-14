import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notas_estudiantes/widgets/cards.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  Timer? _timer; // Definimos el Timer como una variable miembro

  int _currentImageIndex = 0;
  final List<String> _imageList = [
    'assets/escuela1.jpg',
    'assets/escuela2.jpg',
    'assets/escuela3.jpg',
  ];

  int? selectedIndex; // Variable para hacer seguimiento del botón seleccionado

  @override
  void initState() {
    super.initState();
    // Inicia el Timer
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % _imageList.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancelar el Timer cuando el widget se desmonta
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 800),
                child: Container(
                  key: ValueKey<String>(_imageList[_currentImageIndex]),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 200,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      _imageList[_currentImageIndex],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Espacio entre el carrusel y los botones
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        disenoCard(context, 0, Icons.book, 'Asignaturas',
                            'asignaturaTabla', selectedIndex, setState),
                        disenoCard(context, 1, Icons.person, 'Docentes',
                            'docentesTable', selectedIndex, setState),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        disenoCard(context, 2, Icons.group, 'Estudiantes',
                            'estudianteTable', selectedIndex, setState),
                        disenoCard(context, 3, Icons.school, 'Cursos',
                            'cursosTable', selectedIndex, setState),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        disenoCard(context, 4, Icons.grade, 'Notas',
                            'filtroCurso', selectedIndex, setState),
                        disenoCard(context, 5, Icons.settings, 'Configuración',
                            'configuracion', selectedIndex, setState),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
