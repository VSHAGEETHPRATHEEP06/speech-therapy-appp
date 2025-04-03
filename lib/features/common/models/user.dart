class User {
  final String id;
  final String name;
  final String email;
  final String role; // 'patient' or 'therapist'

  User({required this.id, required this.name, required this.email, required this.role});

  // Convert a User object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }

  // Create a User object from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }
}
