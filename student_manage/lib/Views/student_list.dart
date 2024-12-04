import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_manage/Controller/student_controller.dart';
import 'package:student_manage/Views/student_form.dart';
import '../models/student.dart';

class StudentListView extends StatefulWidget {
  const StudentListView({super.key});

  @override
  _StudentListViewState createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  final StudentController controller = StudentController();
  late Future<List<Student>> studentList;

  @override
  void initState() {
    super.initState();
    studentList = controller.getStudents();  // Cargar estudiantes desde la base de datos
  }

  // Refrescar la lista después de realizar una operación
  void refreshList() {
    setState(() {
      studentList = controller.getStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Estudiantes'),
        backgroundColor: const Color.fromARGB(255, 207, 205, 210),  // Color de la AppBar
      ),
      body: FutureBuilder<List<Student>>(
        future: studentList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay estudiantes registrados.'));
          } else {
            final students = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    title: Text('${student.name} ${student.lastName}', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(student.email),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(student.photoUrl),
                      radius: 30,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Color.fromARGB(255, 22, 39, 53)),
                          onPressed: () {
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
                                          refreshList();
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirmar eliminación"),
                                  content: const Text("¿Estás seguro de que deseas eliminar este estudiante?"),
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
                                        await controller.deleteStudent(student.id);
                                        Fluttertoast.showToast(
                                          msg: "El estudiante ha sido eliminado",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                        );
                                        refreshList();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentFormView(controller: controller),
            ),
          ).then((_) {
            refreshList();
          });
        },
        child: const Icon(Icons.add, size: 30),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
