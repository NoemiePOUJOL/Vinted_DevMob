import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class AjouterVetementPage extends StatefulWidget {
  const AjouterVetementPage({super.key});

  @override
  _AjouterVetementPageState createState() => _AjouterVetementPageState();
}

class _AjouterVetementPageState extends State<AjouterVetementPage> {
  final _formKey = GlobalKey<FormState>();
  // Contrôleurs pour les champs de texte relatifs aux données du vêtement
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();
  final TextEditingController _tailleController = TextEditingController();
  final TextEditingController _marqueController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();

  // Méthode pour ajouter un vêtement à Firestore
  Future<void> _ajouterVetement() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Ajouter le vêtement à la collection Firestore 'clothes'
        await FirebaseFirestore.instance.collection('clothes').add({
          'image': _imageController.text,
          'titre': _titreController.text,
          'categorie': _categorieController.text,
          'taille': _tailleController.text,
          'marque': _marqueController.text,
          'prix': double.parse(_prixController.text),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vêtement ajouté avec succès')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout du vêtement : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un Vêtement')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              // Champs de texte pour l'image du vetement 
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer l\'URL de l\'image';
                  }
                  return null;
                },
              ),

              // Champs de texte pour le titre du vetement
              TextFormField(
                controller: _titreController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le titre';
                  }
                  return null;
                },
              ),

              // Champs de texte pour la catégorie du vetement
              TextFormField(
                controller: _categorieController,
                decoration: const InputDecoration(labelText: 'Catégorie'),
                
              ),

              // Champs de texte pour la taille du vetement
              TextFormField(
                controller: _tailleController,
                decoration: const InputDecoration(labelText: 'Taille'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la taille';
                  }
                  return null;
                },
              ),

              // Champs de texte pour la marque du vetement
              TextFormField(
                controller: _marqueController,
                decoration: const InputDecoration(labelText: 'Marque'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la marque';
                  }
                  return null;
                },
              ),

              // Champs de texte pour le prix du vetement
              TextFormField(
                controller: _prixController,
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly], //uniquement des chiffres
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le prix';
                  }
                  return null;
                },
              ),

              // Bouton pour valider l'ajout du vetement
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _ajouterVetement,
                child: const Text('Valider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}