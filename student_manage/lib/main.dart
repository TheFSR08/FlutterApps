import 'package:flutter/material.dart';
import 'package:student_manage/Views/student_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://gzawmepkpyqudcvxhybv.supabase.co', // Reemplaza con tu URL de Supabase
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd6YXdtZXBrcHlxdWRjdnhoeWJ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMyODE0NjksImV4cCI6MjA0ODg1NzQ2OX0.PdHwYHvjYd73ogaDs0QqkKwNG-7iRQ-42E4w95-z3zw', // Reemplaza con tu API Key
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Estudiantes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StudentListView(),
    );
  }
}
