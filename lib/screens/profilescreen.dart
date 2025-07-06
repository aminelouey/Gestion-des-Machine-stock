import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profilescreen extends StatelessWidget {
  const Profilescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Machines')),
      body: Center(child: ElevatedButton(
        onPressed: () async {
           await FirebaseAuth.instance.signOut();
      }, child: Text('Deconnecter')),),
    );
  }
}