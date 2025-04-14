import 'package:notas_estudiantes/enlaces/Enlaces.dart';

class Customizarsnackbar {
  static void mostrarError(BuildContext context, String mensaje) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.error, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(child: Text(mensaje)),
        ],
      ),
      backgroundColor: Colors.red[600],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void mostrarExito(BuildContext context, String mensaje) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(child: Text(mensaje)),
        ],
      ),
      backgroundColor: Colors.green[600],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
