import 'package:flutter/material.dart';
import 'package:gestion_pieces/screens/AccuilScreen.dart';
import 'package:gestion_pieces/screens/Login_screen.dart';
import 'package:gestion_pieces/utils/customNaviBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gestion_pieces/screens/HistoriqueScreen.dart';
import 'package:gestion_pieces/screens/PiecesScreen.dart';
import 'package:gestion_pieces/screens/profilescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestion des Pièces',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return MainNavigationScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Accueilscreen(),
    Piecesscreen(),
    Historiquescreen(),
    Profilescreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _screens[_currentIndex]),
          CustomBottomNavBar(
            selectedIndex: _currentIndex,
            onItemSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            onTap: () {
              // Action pour le scan QR
            },
          ),
        ],
      ),
    );
  }
}
