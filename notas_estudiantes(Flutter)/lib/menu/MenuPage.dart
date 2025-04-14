import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuPage extends StatefulWidget {
  final String title;
  final Widget body;

  const MenuPage({super.key, required this.title, required this.body});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5, // Sombra para dar más profundidad
        backgroundColor: Color(0xFF094263), // Color sólido del AppBar
        centerTitle: true,
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
              'Construyendo conocimiento, forjando valores.',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('U.E Cielo Azul'),
              accountEmail: Text('Gestión de notas estudiantiles'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.school,
                  size: 50,
                  color: Color(0xFF094263),
                ),
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF094263),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                // Navega a la ruta '/inicio' y reemplaza la pantalla actual
                Navigator.pushReplacementNamed(context, 'inicio');
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Asignaturas'),
              onTap: () {
                // Navega a la ruta '/asignaturas' y reemplaza la pantalla actual
                Navigator.pushReplacementNamed(context, 'asignaturaTabla');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Docentes'),
              onTap: () {
                // Navega a la ruta '/docentes' y reemplaza la pantalla actual
                Navigator.pushReplacementNamed(context, 'docentesTable');
              },
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Estudiantes'),
              onTap: () {
                // Navega a la ruta '/estudiantes' y reemplaza la pantalla actual
                Navigator.pushReplacementNamed(context, 'estudianteTable');
              },
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Cursos'),
              onTap: () {
                // Navega a la ruta '/cursos' y reemplaza la pantalla actual
                Navigator.pushReplacementNamed(context, 'cursosTable');
              },
            ),
            ListTile(
              leading: Icon(Icons.grade),
              title: Text('Notas'),
              onTap: () {
                // Navega a la ruta '/notas' y reemplaza la pantalla actual
                Navigator.pushReplacementNamed(context, 'filtroCurso');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {
                // Navega a la ruta '/configuracion' y reemplaza la pantalla actual
                Navigator.pushReplacementNamed(context, 'configuracion');
              },
            ),
          ],
        ),
      ),
      body: widget.body, // El contenido de la página que se pasa como parámetro
      backgroundColor: Colors.white, // Fondo blanco para el contenido principal
    );
  }
}
