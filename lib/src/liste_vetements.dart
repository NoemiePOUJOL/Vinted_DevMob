import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'panier.dart';
import 'profil_user.dart';
import 'detail_vetements.dart';

class ListeVetementsPage extends StatefulWidget {
  const ListeVetementsPage({super.key});

  @override
  _ListeVetementsPageState createState() => _ListeVetementsPageState();
}

class _ListeVetementsPageState extends State<ListeVetementsPage> {
  int _selectedIndex = 0; // Index de l'élément sélectionné dans la barre de navigation
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot>? _vetements; // Liste des vêtements récupérés depuis Firestore

  @override
  void initState() {
    super.initState();
    _fetchVetements(); // Récupérer les vêtements à l'initialisation  
  }

  // Méthode pour récupérer les vêtements depuis Firestore
  Future<void> _fetchVetements() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('clothes').get();
      setState(() {
        _vetements = snapshot.docs; //Stocker les vêtements 
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des vêtements : $e')),
      );
    }
  }

  // Méthode pour gérer la navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      // Cas où l'élément sélectionné est Acheter
      case 0: 
        break;

      // Cas où l'élément sélectionné est Panier
      case 1: 
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PanierPage()),
        );
        break;
      
      // Cas où l'élément sélectionné est Profil
      case 2: 
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilUserPage()),
        );
        break;
    }
  }

  // Méthode pour construire un ListTile à partir d'un DocumentSnapshot
  Widget _buildListTile(DocumentSnapshot vetement) {

    // Extraction des données du document
    final data = vetement.data() as Map<String, dynamic>;
    final image = data['image'] ?? '';
    final titre = data['titre'] ?? 'Titre inconnu';
    final taille = data['taille'] ?? 'Taille inconnue';
    final prix = data['prix']?.toString() ?? 'Prix inconnu';

    return ListTile(
      leading: Image.network(image),
      title: Text(titre),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Taille: $taille'),
          Text('Prix: $prix €'), 
        ],
      ),
      onTap: () {
        // Naviguer vers la page de détail du vêtement
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailVetementPage(vetement: vetement),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liste des Vêtements',
          style: TextStyle(color:  Color.fromARGB(255, 169, 122, 219)),
        ),
      ),
      body: _vetements == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _vetements!.length,
              itemBuilder: (context, index) {
                var vetement = _vetements![index];
                return _buildListTile(vetement);
              },
            ),
      
    );
  }
}