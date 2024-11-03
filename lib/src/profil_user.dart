import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'auth_service.dart';
import 'login.dart'; // Importez la page de login
import 'package:flutter_project/main.dart'; // Importez la page principale
import 'ajout_vetement.dart'; // Importez la page d'ajout de vêtement

class ProfilUserPage extends StatefulWidget {
  const ProfilUserPage({super.key});

  @override
  _ProfilUserPageState createState() => _ProfilUserPageState();
}

class _ProfilUserPageState extends State<ProfilUserPage> {
  // Contrôleurs pour les champs de texte relarifs aux données utilisateur
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _adressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Récupérer les données de l'utilisateur à l'initialisation
  }

  // Récupère l'identifiant de l'utilisateur connecté
  String userId = AuthService().id!;

  // Méthode pour charger les données de l'utilisateur depuis Firestore
  Future<void> _loadUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)  // Récupère le document de l'utilisateur connecté
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        print('User Data: $userData'); 
        setState(() {
          _idController.text = userData['id'] ?? '';
          _passwordController.text = userData['password'] ?? '';
          _birthdayController.text = userData['birthday'] ?? '';
          _adressController.text = userData['adress'] ?? '';
          _cityController.text = userData['city'] ?? '';
          _postalCodeController.text = userData['postalCode'] ?? '';
        });
      } else {
        print('No user data found');
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Méthode pour mettre à jour les données de l'utilisateur
  Future<void> _updateUserData() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'id': _idController.text,
        'password': _passwordController.text,
        'birthday': _birthdayController.text,
        'adress': _adressController.text,
        'city': _cityController.text,
        'postalCode': _postalCodeController.text,
      });
      print('User data updated successfully');
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  // Méthode pour se déconnecter
  Future<void> _signOut() async {
    await AuthService().signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Profil'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [

            //Champs de texte pour l'identifiant (non modifiable)
            TextFormField(
              controller: _idController,
              readOnly: true, // non modifiable
              decoration: const InputDecoration(labelText: 'Login'),
            ),

            //Champs de texte pour le mot de passe (non visible)
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true, //non visible
            ),

            //Champs de texte pour l'anniversaire (sélection de date)
            TextFormField(
              controller: _birthdayController,
              decoration: const InputDecoration(labelText: 'Anniversaire'),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _birthdayController.text =
                        '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                  });
                }
              },
            ),

            //Champs de texte pour l'adresse
            TextFormField(
              controller: _adressController,
              decoration: const InputDecoration(labelText: 'Adresse'),
            ),

            //Champs de texte pour la ville
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'Ville'),
            ),

            //Champs de texte pour le code postal (uniquement des chiffres)
            TextFormField(
              controller: _postalCodeController,
              decoration: const InputDecoration(labelText: 'Code Postal'),
              keyboardType: TextInputType.number, //uniquement des chiffres
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),

            //Bouton pour enregistrer les modifications
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserData,
              child: Text('Enregistrer'),
            ),

            //Bouton pour se déconnecter
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signOut,
              child: Text('Se déconnecter'),
            ),

            //Bouton pour ajouter un vêtement
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AjouterVetementPage()), //Naviguer vers la page d'ajout de vêtement
                );
              },
              child: Text('Ajouter un vêtement'),
            ),
          ],
        ),
      ),
    ),
  );
  }
}