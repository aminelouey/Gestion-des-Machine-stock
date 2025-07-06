import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gestion_pieces/screens/AccuilScreen.dart';
import 'package:gestion_pieces/screens/Login_screen.dart';
import 'package:gestion_pieces/utils/custom_Button.dart';
import 'package:gestion_pieces/utils/custom_textfeild.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _registerUser() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String username = _usernameController.text.trim();

    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Tous les champs sont requis")));
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Enregistrement du nom d'utilisateur dans Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'username': username,
            'email': email,
            'createdAt': Timestamp.now(),
          });
      // ✅ Affiche une SnackBar de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inscription réussie !'),
          backgroundColor: Colors.green,
        ),
      );
      // Optionnel : attendre un peu avant de pop
      await Future.delayed(const Duration(seconds: 1));
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email déjà utilisé.';
          break;
        case 'invalid-email':
          message = 'Email invalide.';
          break;
        case 'weak-password':
          message = 'Mot de passe trop faible.';
          break;
        default:
          message = 'Erreur: ${e.message}';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(120),
              Text(
                'Inscription',
                style: TextStyle(
                  color: Colors.blue,
                  letterSpacing: 1.2,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(80),
              CustomTextfield(
                controller: _usernameController,
                icondata: Icons.person_outline,
                hinText: 'Nom d\'utilisateur',
              ),
              Gap(50),
              CustomTextfield(
                controller: _emailController,
                icondata: Icons.email_outlined,
                hinText: 'Adresse e-mail',
              ),
              Gap(50),
              CustomTextfield(
                controller: _passwordController,
                icondata: Icons.lock_outline,
                hinText: 'Mot de passe',
              ),
              Gap(70),
              CustomButton(title: 'Créer', onPressed: _registerUser),
              Gap(50),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vous avez déjà un compte ?',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        ' Se connecter',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
