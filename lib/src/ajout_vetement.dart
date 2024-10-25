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
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();
  final TextEditingController _tailleController = TextEditingController();
  final TextEditingController _marqueController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();

  Future<void> _ajouterVetement() async {
    if (_formKey.currentState!.validate()) {
      try {
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
              TextFormField(
                controller: _categorieController,
                decoration: const InputDecoration(labelText: 'Catégorie'),
                
              ),
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
              TextFormField(
                controller: _prixController,
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le prix';
                  }
                  return null;
                },
              ),
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