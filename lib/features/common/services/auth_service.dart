
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? profileImage;
  final DateTime? lastLogin;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage,
    this.lastLogin,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'profileImage': profileImage,
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      profileImage: json['profileImage'],
      lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
    );
  }
}

class AuthService {
  // Store the currently logged-in user
  User? _currentUser;
  
  // Get the current user
  User? get currentUser => _currentUser;
  
  // Check if a user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      _currentUser = User.fromJson(jsonDecode(userData));
      return true;
    }
    return false;
  }

  // Login function with hardcoded credentials
  Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Check hardcoded credentials
    if (email == 'Thusha' && password == 'Thusha1115') {
      // Create a mock user
      _currentUser = User(
        id: 1,
        name: 'Thusha',
        email: 'thusha@example.com',
        role: 'therapist',
        lastLogin: DateTime.now(),
        profileImage: 'assets/images/avatar.png',
      );
      
      // Save user data to persistent storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(_currentUser!.toJson()));
      await prefs.setString('auth_token', 'mock_token_${DateTime.now().millisecondsSinceEpoch}');
      
      return true;
    }
    return false;
  }

  // Mock function for sign up
  Future<bool> signUp(String email, String password) async {
    // Simulate network request
    await Future.delayed(Duration(seconds: 2));
    return true; // Successful sign up
  }

  // Mock logout
  Future<void> logout() async {
    // Simulate logout process
    await Future.delayed(Duration(seconds: 1));
  }
}
