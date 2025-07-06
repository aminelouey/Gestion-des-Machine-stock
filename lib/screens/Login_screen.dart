import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gestion_pieces/screens/AccuilScreen.dart';
import 'package:gestion_pieces/screens/signup_screen.dart';
import 'package:gestion_pieces/utils/custom_Button.dart';
import 'package:gestion_pieces/utils/custom_textfeild.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool obscureText = true;
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        throw Exception('empty-fields');
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Accueilscreen()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connexion réussie', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'Aucun utilisateur trouvé pour cet e-mail.';
      } else if (e.code == 'wrong-password') {
        message = 'Mot de passe incorrect.';
      } else if (e.code == 'invalid-email') {
        message = "L'adresse e-mail n'est pas valide.";
      } else if (e.code == 'user-disabled') {
        message = "Ce compte a été désactivé.";
      } else if (e.code == 'too-many-requests') {
        message = "Trop de tentatives. Veuillez réessayer plus tard.";
      } else if (e.code == 'network-request-failed') {
        message = "Erreur réseau. Veuillez vérifier votre connexion internet.";
      } else {
        message = 'E-mail ou mot de passe incorrect.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      final message = e.toString().contains('empty-fields')
          ? 'Veuillez remplir tous les champs.'
          : 'Erreur inattendue : ${e.toString()}';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(120),
              Text(
                'Connexion',
                style: TextStyle(
                  color: Colors.blue,
                  letterSpacing: 1.2,
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(100),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextfield(
                      controller: _emailController,
                      icondata: Icons.email_outlined,
                      hinText: 'E-mail ou nom d\'utilisateur',
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'E-mail requis';
                        if (!value.contains('@')) return 'E-mail invalide';
                        return null;
                      },
                    ),
                    const Gap(40),
                    CustomTextfield(
                      controller: _passwordController,
                      icondata: Icons.lock_outline,
                      hinText: 'Mot de passe',
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Mot de passe requis';
                        if (value.length < 6) return 'Minimum 6 caractères';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              
              const Gap(80),
              _isLoading
                  ? CustomButton(
                      titleWidget: const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: null,
                    )
                  : CustomButton(
                      title: 'Se connecter',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _login();
                        }
                      },
                    ),
              
              const Gap(50),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Vous n'avez pas de compte ?",
                      style: TextStyle(
                        color:  Colors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  SignupScreen()));
                      },
                      child: Text(
                        ' Inscrivez-vous',
                        style: TextStyle(
                          color:  Colors.blue,
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
