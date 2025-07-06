import 'package:flutter/material.dart';

class Piecesscreen extends StatelessWidget {
  const Piecesscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('pieces')),
      body: Center(child: Text('Liste des pièces')),
    );
  }
}