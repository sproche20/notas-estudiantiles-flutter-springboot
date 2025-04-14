import 'package:flutter/material.dart';
import 'package:notas_estudiantes/Calificaciones/CalificacionFinal/view/filtroPorCurso.dart';
import 'package:notas_estudiantes/enlaces/Enlaces.dart';
import 'package:notas_estudiantes/home/configuracion.dart';
import 'package:google_fonts/google_fonts.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedIndex = 0;

  // Mapeo de las categorías principales con sus iconos
  final Map<int, Map<String, dynamic>> _menuTitles = {
    0: {"title": "Inicio", "icon": Icons.home},
    1: {"title": "Asignaturas", "icon": Icons.book},
    2: {"title": "Docentes", "icon": Icons.person},
    3: {"title": "Estudiantes", "icon": Icons.group},
    4: {"title": "Cursos", "icon": Icons.school},
    5: {"title": "Notas Finales", "icon": Icons.grade},
    6: {"title": "Configuración", "icon": Icons.settings},
  };

  final List<Widget> _pages = [
    Inicio(),
    Asignaturastable(),
    Docentetable(),
    Estudiantestable(),
    Cursostable(),
    Filtroporcurso(),
    Configuracion()
  ];

  // Método para manejar la navegación cuando se selecciona un ítem del menú
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Cierra el drawer después de seleccionar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF094263), // Color del AppBar
        title: Column(
          children: [
            Text(
              'U.E Cielo Azul',
              style: GoogleFonts.gabarito(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Gestión de Docentes y Estudiantes',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('U.E Cielo Azul'),
              accountEmail: Text('Educando Siempre para nuestros estudiantes'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.school,
                  size: 50,
                  color: Color(0xFFE91E63),
                ),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 27, 27, 41),
              ),
            ),
            // Listado de opciones del menú
            for (int index = 0; index < _menuTitles.length; index++)
              ListTile(
                leading: Icon(
                  _menuTitles[index]!["icon"],
                  color: Colors.black,
                ),
                title: Text(
                  _menuTitles[index]!["title"],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => _onItemTapped(
                    index), // Cambiar la pantalla al seleccionar un ítem
              ),
          ],
        ),
      ),
      body: _pages[_selectedIndex], // Muestra la página correspondiente
    );
  }
}
