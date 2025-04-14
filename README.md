
# 📚 Sistema de Gestión de Notas Estudiantiles

Aplicación desarrollada para gestionar calificaciones de estudiantes, permitiendo registrar, visualizar y administrar notas por asignatura y calificaciones finales. Combina Flutter para la interfaz gráfica (frontend) y Spring Boot para la lógica de negocio (backend).

## 🚀 Funcionalidades principales

- Registrar estudiantes, asignaturas y docentes.
- Ingresar calificaciones por asignatura.
- Calcular calificaciones finales por estudiante.
- Visualizar las notas organizadas por curso.
- Navegación intuitiva y diseño amigable.

## 🛠️ Tecnologías utilizadas

### Frontend (Flutter)
- Flutter con arquitectura MVC
- Widgets personalizados
- Manejo de formularios y validaciones
- Consumo de API REST

### Backend (Spring Boot)
- Spring Boot 3
- JPA + Hibernate
- PostgreSQL
- Lombok
- Controladores REST

## 📂 Estructura del proyecto

```
📁 backend/
 ├── controlador/
 ├── dto/
 ├── modelo/
 ├── repositorio/
 ├── servicio/
 └── restcontroller/

📁 frontend/
 ├── pages/
 ├── models/
 ├── controller/
 └── widgets/
```

## ⚙️ Cómo ejecutar el proyecto

### Backend
1. Clona el repositorio.
2. Configura la base de datos PostgreSQL.
3. Ejecuta el proyecto desde tu IDE (IntelliJ, Spring Tools, etc.).
4. Asegúrate que la API corra en `http://localhost:8080`.

### Frontend
1. Abre la carpeta del frontend con VS Code o Android Studio.
2. Ejecuta el comando:  
   ```
   flutter pub get
   flutter run
   ```
3. Asegúrate de tener un emulador o dispositivo conectado.

## 📸 Capturas de pantalla

*(Aquí puedes subir imágenes del formulario, tablas de notas, etc.)*

## 👨‍💻 Autor

- Nombre: Paúl Roche
- GitHub: [@sproche20]https://github.com/sproche20

---

> Este proyecto fue desarrollado como práctica para reforzar el uso combinado de Flutter y Spring Boot en una aplicación educativa real.
