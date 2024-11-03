import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class PanierPage extends StatefulWidget {
  const PanierPage({super.key});

  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  List<DocumentSnapshot>? _panierItems; //Liste des éléments du panier 
  double _total = 0.0; //Total du panier

  @override
  void initState() {
    super.initState();
    _fetchPanierItems(); //Récupérer les éléments du panier à l'initialisation
  }

  //Méthode pour récupérer les éléments du panier
  Future<void> _fetchPanierItems() async {
    String? userId = _authService.id; //Récupérer l'identifiant de l'utilisateur connecté
    if (userId != null) {
      QuerySnapshot snapshot = await _firestore.collection('users').doc(userId).collection('panier').get();
      setState(() {
        _panierItems = snapshot.docs; //Récupérer les éléments du panier
        _total = _panierItems!.fold(0.0, (sum, item) => sum + (item['prix'] as num).toDouble()); //Calculer le total du panier
      });
      print('Panier items: $_panierItems');
    }
  }

  //Méthode pour supprimer un élément du panier
  Future<void> _removeFromPanier(DocumentSnapshot item) async {
    String? userId = _authService.id;
    if (userId != null) {
      await _firestore.collection('users').doc(userId).collection('panier').doc(item.id).delete();
      setState(() {
        _panierItems!.remove(item); //Supprimer l'élément du panier
        _total -= (item['prix'] as num).toDouble(); //Mettre à jour le total du panier
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon Panier')), //Titre de la page
      body: _panierItems == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [

                //Liste des éléments du panier
                Expanded(
                  child: ListView.builder(
                    itemCount: _panierItems!.length, //Nombre d'éléments du panier
                    itemBuilder: (context, index) {
                      var item = _panierItems![index];
                      return ListTile(
                        leading: Image.network(item['image']), //Afficher l'image de l'élément
                        title: Text(item['titre']), //Afficher le titre de l'élément
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Taille: ${item['taille']}'), //Afficher la taille de l'élément
                            Text('Prix: ${item['prix']} €'), //Afficher le prix de l'élément
                          ],
                        ),

                        //Bouton pour supprimer l'élément du panier
                        trailing: IconButton(
                          icon: const Icon(Icons.close), //Icône de suppression
                          onPressed: () => _removeFromPanier(item), //Appeler la méthode pour supprimer l'élément
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Total: $_total €', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), //Afficher le total du panier
                ),
              ],
            ),
    );
  }
}