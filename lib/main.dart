import 'package:flutter/material.dart';
import 'package:flutter_app/core/theme/theme.dart';
import 'package:flutter_app/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_app/core/supabase_config.dart';
import 'package:flutter_app/features/home/presentation/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // theme: AppTheme.darkThemeMode,
      initialRoute: '/signup',
      routes: {
        '/': (context) => const MyHomePage(),
        '/signup': (context) => const SignUpPage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}