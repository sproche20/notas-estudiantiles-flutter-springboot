import 'package:flutter/material.dart';

// Función para el diseño de las tarjetas (botones)
Widget disenoCard(BuildContext context, int index, IconData icon,
    String descripcion, String ruta, int? selectedIndex, Function setState) {
  bool isSelected = selectedIndex == index; // Verifica si está seleccionada
  return GestureDetector(
    onTap: () {
      setState(() {
        selectedIndex = isSelected ? null : index; // Cambia la selección
      });

      // Navegar a la página correspondiente
      Navigator.pushNamed(
          context, ruta); // Usamos Navigator.pushNamed para navegar por ruta
    },
    child: SizedBox(
      width: 180,
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: isSelected ? Colors.blue : const Color(0xFF094263),
            width: 3,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 60,
                color: isSelected ? Colors.blue : const Color(0xFF094263),
              ),
              const SizedBox(height: 10),
              Text(
                descripcion,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
