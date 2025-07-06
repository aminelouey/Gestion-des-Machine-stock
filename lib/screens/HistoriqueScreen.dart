import 'package:flutter/material.dart';

class Historiquescreen extends StatelessWidget {
  const Historiquescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Historique')),
      body: Center(child: Text('Historique des interventions')),
    );
  }
}