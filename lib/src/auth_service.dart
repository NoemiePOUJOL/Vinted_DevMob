class AuthService {
  static final AuthService _instance = AuthService._internal();

  String? id;
  String? password;

  factory AuthService() {
    return _instance;
  }

  Future<void> signOut() async {
    // Logique pour déconnecter l'utilisateur
    id = null;
    password = null;
  }

  AuthService._internal();
}