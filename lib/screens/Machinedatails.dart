import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:firebase_database/firebase_database.dart';

class Machinedatails extends StatefulWidget {
  final String imageUrl;
  final Map<dynamic, dynamic> machine;
  const Machinedatails({super.key, required this.imageUrl, required this.machine});

  @override
  State<Machinedatails> createState() => _MachinedatailsState();
}

class _MachinedatailsState extends State<Machinedatails> {
  List<Map<dynamic, dynamic>> pieces = [];

  @override
  void initState() {
    super.initState();
    fetchMachinePieces();
  }

  void fetchMachinePieces() async {
    try {
      final nomMachine = widget.machine['nom'];
      final snapshot = await FirebaseDatabase.instance.ref().child('0/machines').get();
      if (snapshot.exists && snapshot.value is List) {
        final machines = List<Map<dynamic, dynamic>>.from(snapshot.value as List);
        final matchedMachine = machines.firstWhere(
          (machine) => machine['nom'] == nomMachine,
          orElse: () => {},
        );
        if (matchedMachine.containsKey('pieces')) {
          final rawPieces = matchedMachine['pieces'];
          if (rawPieces is List) {
            setState(() {
              pieces = List<Map<dynamic, dynamic>>.from(rawPieces);
            });
          }
        }
      }
    } catch (e) {
      print('Erreur récupération pièces: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            imageHeader(context),
            const Gap(15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.machine['nom'] ?? 'Nom de la machine',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Gap(10),
                  Text(
                    'Description détaillée de la machine ici.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Gap(20),
                  Text(
                    'Pièces associées :',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Gap(10),
                  pieceTable(),
                  const Gap(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Retirer une pièce du stock',
                          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageHeader(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Stack(
        children: [
          Image.network(
            widget.imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 40,
            left: 15,
            child: CircleAvatar(
              backgroundColor: Colors.white38.withOpacity(0.9),
              radius: 25,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 25,
            child: CircleAvatar(
              backgroundColor: Colors.white38.withOpacity(0.8),
              radius: 25,
              child: IconButton(
                icon: const Icon(Icons.camera_alt_outlined, color: Colors.black, size: 30),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget pieceTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Expanded(child: Text('Nom Pièce', style: TextStyle(fontWeight: FontWeight.bold))),
                Spacer(),
                Expanded(child: Text('Code ID', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              itemCount: pieces.length,
              itemBuilder: (context, index) {
                final piece = pieces[index];
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: Text(piece['nom'] ?? 'Inconnu')),
                      const Spacer(),
                      Expanded(child: Text(piece['code'] ?? '')),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
