class SessionService {
  // Session handling methods will go here
  static String? _userId;

  // Store user session
  static void storeUserSession(String userId) {
    _userId = userId;
  }

  // Retrieve user session
  static String? getUserSession() {
    return _userId;
  }

  // Clear user session
  static void clearSession() {
    _userId = null;
  }
}
