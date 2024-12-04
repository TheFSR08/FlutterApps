// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:student_manage/Views/student_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/student.dart';

class StudentController {
  final SupabaseClient supabase = Supabase.instance.client;

  // Obtener lista de estudiantes
Future<List<Student>> getStudents() async {
  final response = await supabase.from('students').select();

  print('Respuesta del servidor: $response');

  // ignore: unnecessary_null_comparison
  if (response == null || response.error != null) {
    throw Exception('Error al obtener los estudiantes: ${response.error?.message ?? 'Respuesta nula'}');
  }

  // Verifica si la respuesta es una lista de mapas JSON
  // ignore: unnecessary_type_check
  if (response is List && response.isNotEmpty) {
  return response.map((e) {
    try {
      // ignore: unnecessary_cast
      return Student.fromMap(e as Map<String, dynamic>);
    } catch (e) {
      print('Error al mapear el estudiante: $e');
      return null;
    }
  }).where((student) => student != null).toList().cast<Student>();
} else {
  throw Exception('No se encontraron estudiantes o el formato es inválido.');
}

}


  void navigateToAnotherView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StudentListView()),
    );
  }

  // Agregar un nuevo estudiante
  Future<void> addStudent(Student student, BuildContext context) async {
    final response = await supabase.from('students').insert({
      'name': student.name,
      'lastname': student.lastName,
      'grade': student.grade,
      'email': student.email,
      'photourl': student.photoUrl,
    });

    if (response.error != null) {
      throw response.error!;
    }
    // ignore: use_build_context_synchronously
    navigateToAnotherView(context);
  }

  // Actualizar un estudiante existente
Future<void> updateStudent(int id, Student newStudent, BuildContext context) async {
  final response = await supabase.from('students').update({
    'name': newStudent.name,
    'lastname': newStudent.lastName,
    'grade': newStudent.grade, // Valida el tipo
    'email': newStudent.email,
    'photourl': newStudent.photoUrl,
  }).eq('id', id);

  if (response.error != null) {
    throw Exception('Error al actualizar estudiante: ${response.error!.message}');
  }
   // ignore: use_build_context_synchronously
   navigateToAnotherView(context);
}


  // Eliminar un estudiante
  Future<void> deleteStudent(int id) async {
    final response = await supabase.from('students').delete().eq('id', id);

    if (response.error != null) {
      throw response.error!;
    }
  }
}

extension on PostgrestList {
  get error => null;

  get data => null;
}
