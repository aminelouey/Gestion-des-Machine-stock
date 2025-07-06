import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gestion_pieces/models/infocardshome.dart';
import 'package:gestion_pieces/screens/Machinedatails.dart';
import 'package:gestion_pieces/utils/customcardmachine.dart';
import 'package:firebase_database/firebase_database.dart';

class Accueilscreen extends StatefulWidget {
  const Accueilscreen({super.key});

  @override
  State<Accueilscreen> createState() => _AccueilscreenState();
}

class _AccueilscreenState extends State<Accueilscreen> {
  final dbRef = FirebaseDatabase.instance.ref().child('0/machines');
  
  int machineCount = 0;

  @override
  void initState() {
    super.initState();
    fetchMachinesnames().then((machines) {
      setState(() {
        machineCount = machines.length;
      });
    });
  }

  Future<List<Map<dynamic, dynamic>>> fetchMachinesnames() async {
    try {
      final snapshot = await dbRef.get();
      if (snapshot.exists && snapshot.value is List) {
        return List<Map<dynamic, dynamic>>.from(snapshot.value as List);
      }
    } catch (e) {
      print('Erreur lors de la récupération: $e');
    }
    return [];
  }

  List<String> images = [
    'https://nargesa.com/sites/default/files/styles/blog_main_image_l/public/maquinaria%20industrial%20nargesa.png.webp?itok=-DTrRk4T',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-B6P7BoffYp9jqGdz4OenZVtkVSowppXRwg&s',
    'https://www.info-industrielle.fr/wp-content/uploads/Machine-industrielle.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTw_m0sRwz7bjMPzbm3nI3wiCKt1WB7Hhd1rA&s'
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8RYZA4a8-6trzWq9w0hdTnxjWLe3JCkGODw&s'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                blueContainer(),
                const Gap(90),
                FutureBuilder<List<Map<dynamic, dynamic>>>(
                  future: fetchMachinesnames(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final machinesData = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: machinesData.length,
                        itemBuilder: (context, index) {
                          final machine = machinesData[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (c) => Machinedatails(
                                imageUrl: images[index % images.length],
                                machine: machine,
                              )));
                            },
                            child: Customcardmachine(
                              Name: machine['nom'] ?? 'Nom inconnu',
                              Networkimage:
                              images[index % images.length],
                              Status: 'en service',
                              Description:
                                  'Machine industrielle de type ${machine['nom'] ?? '???'}.',
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                          child: Text('Aucune machine trouvée'));
                    }
                  },
                ),
                const Gap(100),
              ],
            ),
            Positioned(
              top: 160,
              left: 20,
              right: 20,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InfoCard(title: 'Machines', value: machineCount.toString()),
                    const InfoCard(title: 'Pieces', value: '266'),
                    const InfoCard(title: 'Alertes', value: '2'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget blueContainer() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.blue,
      alignment: Alignment.centerLeft,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Bienvenue !',
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
