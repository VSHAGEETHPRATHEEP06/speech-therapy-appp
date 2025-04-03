import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Feature imports
import 'features/auth/login_page.dart';
import 'features/auth/registration_page.dart';
import 'features/home/home_page.dart';
import 'features/exercises/exercises_page.dart';
import 'features/exercises/exercise_detail_page.dart';
import 'features/progress/progress_reports_page.dart';
import 'features/progress/progress_report_detail_page.dart';
import 'features/therapy/therapy_session_detail_page.dart';
import 'features/profile/profile_page.dart';

void main() async {
  // Initialize the app
  WidgetsFlutterBinding.ensureInitialized();
  
  // Check login status
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  
  // Run the app
  runApp(SpeechTherapyApp(isLoggedIn: isLoggedIn));
}

class SpeechTherapyApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const SpeechTherapyApp({super.key, this.isLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech Therapy App',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, 
            foregroundColor: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.grey[100],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          labelStyle: GoogleFonts.poppins(
            color: Colors.grey[700],
          ),
        ),
        colorScheme: ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.grey[800]!,
          onPrimary: Colors.white,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      // Localization support
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ta'), // Tamil
        Locale('si'), // Sinhala
      ],
      initialRoute: isLoggedIn ? '/home' : '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/home': (context) => const HomePage(),
        '/exercises': (context) => const ExercisesPage(),
        '/exercises/detail': (context) => const ExerciseDetailPage(),
        '/progress': (context) => const ProgressReportsPage(),
        '/progress/report/detail': (context) => const ProgressReportDetailPage(),
        '/therapy/session': (context) => const TherapySessionDetailPage(),
        '/profile': (context) => const ProfilePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
