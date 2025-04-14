import 'package:notas_estudiantes/Calificaciones/CalificacionFinal/view/filtroPorCurso.dart';
import 'package:notas_estudiantes/enlaces/Enlaces.dart';
import 'package:notas_estudiantes/home/configuracion.dart';
import 'package:notas_estudiantes/menu/MenuPage.dart';
import 'package:provider/provider.dart';
import 'theme_manager.dart'; // Importa el archivo que creaste

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeManager(), // Proveedor de estado para el tema
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: 'inicio', // Ruta inicial sin el slash
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeManager.themeMode, // Usar el estado del tema
          routes: {
            'inicio': (context) => MenuPage(
                  title: 'Menú Principal',
                  body: Inicio(), // Página de inicio
                ),
            'asignaturas': (context) => Asignaturaform(),
            'cursos': (context) => Cursosform(),
            'docentes': (context) => Docentesform(),
            'estudiantes': (context) => Estudiantesform(),
            'notasAsignatura': (context) => Calificacionasignaturaform(),
            'cursosTable': (context) => MenuPage(
                  title: 'Cursos Table',
                  body: Cursostable(), // Página de tabla de cursos
                ),
            'docentesTable': (context) => MenuPage(
                  title: 'Docentes Table',
                  body: Docentetable(), // Página de tabla de docentes
                ),
            'estudianteTable': (context) => MenuPage(
                  title: 'Estudiantes Table',
                  body: Estudiantestable(), // Página de tabla de estudiantes
                ),
            'asignaturaTabla': (context) => MenuPage(
                  title: 'Asignaturas Table',
                  body: Asignaturastable(), // Página de tabla de asignaturas
                ),
            'configuracion': (context) => MenuPage(
                  title: 'Configuración',
                  body: Configuracion(), // Página de configuración
                ),
            'filtroCurso': (context) => MenuPage(
                  title: 'Filtro por Curso',
                  body: Filtroporcurso(), // Página de filtro por curso
                ),
          },
        );
      },
    );
  }
}
