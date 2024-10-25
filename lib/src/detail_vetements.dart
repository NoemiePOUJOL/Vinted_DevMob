import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';

class DetailVetementPage extends StatelessWidget {
  final DocumentSnapshot<Object?> vetement;

  const DetailVetementPage({super.key, required this.vetement});

  @override
  Widget build(BuildContext context) {
    // Extraction des données du document
    final data = vetement.data() as Map<String, dynamic>;
    final image = data['image'] ?? '';
    final titre = data['titre'] ?? '';
    final categorie = data['categorie'] ?? '';
    final taille = data['taille'] ?? '';
    final marque = data['marque'] ?? '';
    final prix = data['prix'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Détails du Vêtement',
          style: TextStyle(color: Color.fromARGB(255, 169, 122, 219)),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(image, height: 200, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text('Titre : $titre', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text('Catégorie : $categorie', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text('Taille : $taille', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text('Marque : $marque', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text('Prix : $prix€', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _addToCart(context, vetement);
                      },
                      child: const Text('Ajouter au panier'),
                    ),
                  ),
                ],
              
            
          ),
        ),
    );
  }

  void _addToCart(BuildContext context, DocumentSnapshot<Object?> vetement) async {
    // Ajout du vêtement au panier de l'utilisateur dans Firestore
    final userId = AuthService().id!; // Remplacez par l'ID de l'utilisateur connecté
    final cartCollection = FirebaseFirestore.instance.collection('users').doc(userId).collection('panier');

    await cartCollection.add({
      'vetementId': vetement.id,
      'titre': vetement['titre'],
      'prix': vetement['prix'],
      'image': vetement['image'],
      'taille': vetement['taille'],
      'quantité': 1,
    });

    print('Vêtement ajouté au panier : ${vetement['titre']}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vêtement ajouté au panier')),
    );
  }
}

