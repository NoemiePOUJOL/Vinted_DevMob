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
  List<DocumentSnapshot>? _panierItems;
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchPanierItems();
  }

  Future<void> _fetchPanierItems() async {
    String? userId = _authService.id;
    if (userId != null) {
      QuerySnapshot snapshot = await _firestore.collection('users').doc(userId).collection('panier').get();
      setState(() {
        _panierItems = snapshot.docs;
        _total = _panierItems!.fold(0.0, (sum, item) => sum + (item['prix'] as num).toDouble());
      });
      print('Panier items: $_panierItems');
    }
  }

  Future<void> _removeFromPanier(DocumentSnapshot item) async {
    String? userId = _authService.id;
    if (userId != null) {
      await _firestore.collection('users').doc(userId).collection('panier').doc(item.id).delete();
      setState(() {
        _panierItems!.remove(item);
        _total -= (item['prix'] as num).toDouble();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon Panier')),
      body: _panierItems == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _panierItems!.length,
                    itemBuilder: (context, index) {
                      var item = _panierItems![index];
                      return ListTile(
                        leading: Image.network(item['image']),
                        title: Text(item['titre']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Taille: ${item['taille']}'),
                            Text('Prix: ${item['prix']} €'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => _removeFromPanier(item),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Total: $_total €', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
    );
  }
}