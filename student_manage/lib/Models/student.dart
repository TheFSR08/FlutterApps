class Student {
  final int id;
  final String name;
  final String lastName;
  final String grade;
  final String email;
  final String photoUrl;

  // Constructor de la clase Student
  Student({
    required this.id,
    required this.name,
    required this.lastName,
    required this.grade,
    required this.email,
    required this.photoUrl,
  });

  // Método para convertir un mapa a un objeto Student
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as int,
      name: map['name'] as String,
      lastName: map['lastname'] as String,
      grade: map['grade'] as String,
      email: map['email'] as String,
      photoUrl: map['photourl'] as String,
    );
  }

  // Método para convertir un objeto Student a un mapa (opcional)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastname': lastName,
      'grade': grade,
      'email': email,
      'photourl': photoUrl,
    };
  }
}
