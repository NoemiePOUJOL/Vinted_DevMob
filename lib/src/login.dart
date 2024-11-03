import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project/src/auth_service.dart';
import 'auth_service.dart';

// Classe LoginPage pour la connexion de l'utilisateur
class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); 
  final TextEditingController _idController = TextEditingController(); // Contrôleur pour le champ identifiant
  final TextEditingController _passwordController = TextEditingController(); // Contrôleur pour le champ mot de passe
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Instance de Firestore

  // Méthode pour gérer la connexion de l'utilisateur
  Future<void> _login() async {
    final id = _idController.text;
    final password = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      try {
        // Recherche dans Firestore
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .where('id', isEqualTo: id)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var userDoc = querySnapshot.docs.first;

          // Vérifier si le mot de passe correspond
          if (userDoc['password'] == password) {
            // Stockage de l'identifiant et du mot de passe dans AuthService
            AuthService().id = id;
            AuthService().password = password;
            print(AuthService().id);

            // Cas où la connexion est réussie
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Connexion réussie')),
            );

            widget.onLoginSuccess();
          } else {
            // Cas mot de passe incorrect
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mot de passe incorrect')),
            );
          }
        } else {
          // Cas utilisateur introuvable
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Utilisateur introuvable')),
          );
        }
      } catch (e) {
        // Gestion des erreurs de connexion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      //Elements de l'app bar
      appBar: AppBar(
        title: const Center(
          child: Text(
            'MIAGED',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 169, 122, 219),
      ),

      //Elements relatifs au formulaire de connexion
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                // Champ pour l'identifiant
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: 'Login',
                      hintText: "Entrez votre identifiant",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre identifiant';
                      }
                      return null;
                    },
                  ),
                ),

                // Champ pour le mot de passe
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: "Entrez votre mot de passe",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre mot de passe';
                      }
                      return null;
                    },
                  ),
                ),

                // Bouton pour valider le formulaire de connexion
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    child: const Text("Se connecter"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}