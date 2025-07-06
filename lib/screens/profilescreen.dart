import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {

  bool switchvalue = true; // Initial value for the switch
    Future<String> _getUserName(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return doc.data()?['username'] ?? 'Nom non disponible';
    } catch (e) {
      return 'Erreur de chargement';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(80),
            Center(
              child: Column(
                children: [
                   CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white, size: 50),
                  ),
                  const SizedBox(height: 12),
                  if (user != null)
                    FutureBuilder<String>(
                      future: _getUserName(user.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          return Text(
                            snapshot.data ?? 'Nom non disponible',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          );
                        }
                      },
                    ),
                  Gap(10),
                  Text(
                    user?.email ?? 'email non disponible',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Paramètres',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.notifications_active_outlined, color: Colors.blue),
                title: const Text('Notifications'),
                trailing: Switch(
                  value: switchvalue,
                  activeColor: Colors.blue,
                  onChanged: (value) {
                    setState(() {
                      switchvalue = !switchvalue;
                    });
                  },
                ),
              ),
            ),
            Gap(50),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Déconnexion'),
              ),
            )
          ],
        ),
      ),
    );
  }
}