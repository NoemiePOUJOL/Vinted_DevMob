import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'firebase_options.dart';
import 'src/login.dart' as login;
import 'src/liste_vetements.dart'; // Import pour afficher la page liste de vetements
import 'src/panier.dart'; // Import pour afficher la page panier
import 'src/profil_user.dart'; // Import pour afficher la page du profil

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // Initialisation de Firebase
  runApp(const MyApp());
}

// Classe principale de l'application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIAGED', // Titre de l'application

      //Theme de l'application
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),

      // Page d'accueil de l'application
      home: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator( //Indicateur de chargement
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            );

          } else if (snapshot.hasData) {
            // Si l'utilisateur est connecté, afficher la page principale
            return const MainPage();

          } else {
            // Si l'utilisateur n'est pas connecté, afficher la page de connexion
            return login.LoginPage(
              onLoginSuccess: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Classe principale qui contient la barre de navigation
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; // Index de l'élément sélectionné

  // Liste des pages pour la navigation
  final List<Widget> _pages = [
    const ListeVetementsPage(),
    const PanierPage(),
    ProfilUserPage(), 
  ];

  // Méthode pour gérer le changement de page
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Met à jour l'index sélectionné
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Center(
          child: Text(
            'MIAGED',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 169, 122, 219),
      ),

      //Barre de navigation
      body: _pages[_selectedIndex], // Affiche la page correspondant à l'index sélectionné
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[

          // Bouton acheter et page liste de vetements
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Acheter',
          ),

          // Bouton panier et page panier
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          
          // Bouton profil et page profil
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 169, 122, 219),
        onTap: _onItemTapped,
      ),
    );
  }
}