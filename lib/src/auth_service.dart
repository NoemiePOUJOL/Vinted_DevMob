//Class pour gérer l'authentification de l'utilisateur
class AuthService {
  static final AuthService _instance = AuthService._internal();

  // Pour stocker l'identifiant et le mot de passe de l'utilisateur
  String? id;
  String? password;

  factory AuthService() {
    return _instance;
  }

  Future<void> signOut() async {
    // Pour déconnecter l'utilisateur on réinitialise les valeurs de l'identifiant et du mot de passe
    id = null;
    password = null;
  }
  
  AuthService._internal();
}