import 'package:flutter/material.dart';
import 'package:notas_estudiantes/theme_manager.dart';
import 'package:provider/provider.dart'; // Asegúrate de importar provider

class Configuracion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF094263),
        title: Text(
          'Configuración',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // Botón para cambiar el tema
              ElevatedButton(
                onPressed: () {
                  themeManager.toggleTheme(); // Cambiar el tema
                },
                child: Text('Cambiar Tema'),
              ),
              // Aquí puedes agregar más botones o configuraciones si lo deseas
            ],
          ),
        ),
      ),
    );
  }
}
