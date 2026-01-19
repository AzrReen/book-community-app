import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart'; // ✅ Added Provider
import 'firebase_options.dart';
import 'main_screen.dart';
import 'screens/login_screen.dart'; // ✅ Import Login Screen
import 'providers/auth_provider.dart'; // ✅ Import Auth Provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎨 YOUR THEME COLORS
    const Color colorBark = Color(0xFF41302C);
    const Color colorSienna = Color(0xFF854D49);
    const Color colorCream = Color(0xFFF7F3E8);

    // ✅ WRAP WITH MULTIPROVIDER
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Biblioo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: colorCream,
          colorScheme: ColorScheme.fromSeed(
            seedColor: colorBark,
            primary: colorBark,
            secondary: colorSienna,
            surface: Colors.white,
            background: colorCream,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: colorBark,
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: colorSienna,
            foregroundColor: Colors.white,
          ),
          // ✅ FIX: Using CardThemeData instead of CardTheme
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.zero,
          ),
        ),
        // ✅ LOGIC: Check if user is logged in
        home: const AuthWrapper(),
      ),
    );
  }
}

// ✅ NEW WIDGET: Decides between Login and Main Screen
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        // If logged in, go to MainScreen (Marketplace). If not, LoginScreen.
        return auth.isAuthenticated ? const MainScreen() : const LoginScreen();
      },
    );
  }
}