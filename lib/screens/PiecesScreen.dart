import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gap/gap.dart';
import 'package:gestion_pieces/utils/customSearchBar.dart';

class Piecesscreen extends StatefulWidget {
  const Piecesscreen({super.key});

  @override
  State<Piecesscreen> createState() => _PiecesscreenState();
}

class _PiecesscreenState extends State<Piecesscreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('stock_pieces');
  Map<dynamic, dynamic>? pieces;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final dataSnapshot = await _dbRef.get();
    if (dataSnapshot.exists) {
      setState(() {
        pieces = dataSnapshot.value as Map<dynamic, dynamic>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pieces == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                Gap(50),
                Customsearchbar(),

                Gap(20),
                Expanded(
                  child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: pieces!.entries.map((entry) {
                        final code = entry.key;
                        final data = entry.value;
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text('${data['designation'] ?? 'Sans nom'}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Gap(5),
                                Text('Code ID :   $code'),
                                Text('Stock initial :    ${data['stock_initial'] ?? 0}'),
                                Text('Stock minimum :   ${data['stock_min'] ?? 0}'),
                              ],
                            ),
                            leading: CircleAvatar(child: Text(data['designation'] .toString().substring(0, 2))),
                          ),
                        );
                      }).toList(),
                    ),
                ),
              ],
            ),
          ),
    );
  }
}
