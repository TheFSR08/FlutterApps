import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_manage/Controller/student_controller.dart';
import 'package:student_manage/Views/student_list.dart';
import '../models/student.dart';

class StudentFormView extends StatelessWidget {
  final StudentController controller;
  final Student? student;

  StudentFormView({super.key, required this.controller, this.student});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _gradeController = TextEditingController();
  final _emailController = TextEditingController();
  final _photoController = TextEditingController();
  
  get label => null;

  @override
  Widget build(BuildContext context) {
    if (student != null) {
      _nameController.text = student!.name;
      _lastNameController.text = student!.lastName;
      _gradeController.text = student!.grade.toString();
      _emailController.text = student!.email;
      _photoController.text = student!.photoUrl;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(student == null ? 'Nuevo Estudiante' : 'Editar Estudiante'),
        backgroundColor: const Color.fromARGB(255, 183, 180, 189), // Color más moderno para el AppBar
        elevation: 0, // Eliminar sombra para un look más limpio
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
         child: Form(
          key: _formKey,
          child: ListView(
            children: [
        // Texto encima del formulario
        const Text(
          'Crear Nuevo Estudiante',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 15, 1, 39),
              ),
              textAlign: TextAlign.center               
              ),
              const SizedBox(height: 16), // Espaciado entre el texto y el formulario
            
              // Nombre
              _buildTextField(
                controller: _nameController,
                label: 'Nombre',
                hintText: 'Ingresa el nombre',
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty || !RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                    return 'Nombre inválido. Solo se permiten letras.';
                  }
                  return null;
                },
              ),
              // Apellido
              _buildTextField(
                controller: _lastNameController,
                label: 'Apellido',
                hintText: 'Ingresa el apellido',
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty || !RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                    return 'Apellido inválido. Solo se permiten letras.';
                  }
                  return null;
                },
              ),
              // Nota
              _buildTextField(
                controller: _gradeController,
                label: 'Nota',
                hintText: 'Ingresa la nota',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null) {
                    return 'La nota debe ser un número.';
                  }
                  return null;
                },
              ),
              // Correo
              _buildTextField(
                controller: _emailController,
                label: 'Correo',
                hintText: 'Ingresa el correo',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                    return 'Correo inválido';
                  }
                  return null;
                },
              ),
              // Foto URL
              _buildTextField(
                controller: _photoController,
                label: 'Foto URL',
                hintText: 'Ingresa la URL de la foto',
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una URL de foto.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Botón guardar o actualizar
              _buildButton(
                context,
                label: student == null ? 'Guardar Estudiante' : 'Actualizar Estudiante',
                color: const Color.fromARGB(255, 244, 251, 254),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    var id = student?.id ?? '0'; // Si es un nuevo estudiante, ID es '0'
                    Student newStudent = Student(
                      id: int.parse(id.toString()),
                      name: _nameController.text,
                      lastName: _lastNameController.text,
                      grade: _gradeController.text,
                      email: _emailController.text,
                      photoUrl: _photoController.text,
                    );
                    if (student == null) {
                      // Agregar estudiante
                      await controller.addStudent(newStudent, context);
                    } else {
                      // Actualizar estudiante
                       showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirmar actualización"),
                                  content: const Text("¿Deseas actualizar la información de este estudiante?"),
                                  actions: [
                                    TextButton(
                                      child: const Text("No"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("Sí"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StudentFormView(
                                              controller: controller,
                                              student: student,
                                            ),
                                          ),
                                        ).then((_) {
                                          Fluttertoast.showToast(
                                            msg: "El estudiante ha sido actualizado",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.blue,
                                            textColor: Colors.white,
                                          );
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                     // await controller.updateStudent(student!.id, newStudent, context);
                    }
                    navigateToAnotherView(context);
                  }
                },
              ),
              const SizedBox(height: 16),
              // Botón de eliminación si es necesario
              if (student != null)
                _buildButton(
                  context,
                  label: 'Eliminar Estudiante',
                  color: const Color.fromARGB(255, 205, 186, 184),
                  onPressed: () async {
                    showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirmar eliminación"),
                                  content: const Text(
                                      "¿Estás seguro de que deseas eliminar este estudiante?"),
                                  actions: [
                                    TextButton(
                                      child: const Text("No"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("Sí"),
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        await controller
                                            .deleteStudent(student!.id);
                                        Fluttertoast.showToast(
                                          msg:
                                              "El estudiante ha sido eliminado",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                        );                                        
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                  //  await controller.deleteStudent(student!.id); // Eliminar estudiante
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Función para crear un TextFormField con estilo moderno
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required TextInputType keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2.0),
          ),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  // Botón con estilo moderno
  Widget _buildButton(BuildContext context, {required String label, required VoidCallback onPressed, Color? color}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.deepPurple, // Color de fondo
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Bordes redondeados
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

void navigateToAnotherView(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const StudentListView()),
  );
}
