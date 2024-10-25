import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'auth_service.dart';
import 'login.dart'; // Importez la page de login
import 'ajout_vetement.dart'; // Importez la page d'ajout de vêtement

class ProfilUserPage extends StatefulWidget {
  const ProfilUserPage({super.key});

  @override
  _ProfilUserPageState createState() => _ProfilUserPageState();
}

class _ProfilUserPageState extends State<ProfilUserPage> {
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

  // Remplace cette valeur par un identifiant utilisateur récupéré ailleurs
  String userId = AuthService().id!;

  Future<void> _loadUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)  // Utilisation de l'identifiant Firestore
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        print('User Data: $userData'); // Affiche les données utilisateur dans la console
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

  Future<void> _signOut() async {
    await AuthService().signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage(onLoginSuccess: () {})),
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
        child: Column(
          children: [
            TextFormField(
              controller: _idController,
              readOnly: true, // non modifiable
              decoration: const InputDecoration(labelText: 'Login'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true, //non visible
            ),
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
            TextFormField(
              controller: _adressController,
              decoration: const InputDecoration(labelText: 'Adresse'),
            ),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'Ville'),
            ),
            TextFormField(
              controller: _postalCodeController,
              decoration: const InputDecoration(labelText: 'Code Postal'),
              keyboardType: TextInputType.number, //uniquement des chiffres
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserData,
              child: Text('Enregistrer'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signOut,
              child: Text('Se déconnecter'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AjouterVetementPage()),
                );
              },
              child: Text('Ajouter un vêtement'),
            ),
          ],
        ),
      ),
    );
  }
}