import 'package:flutter/material.dart';
import 'package:flutter_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_app/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_app/features/home/presentation/home_page.dart';
import 'package:flutter_app/init_dependencies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AppUserCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthUserLogin());
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // theme: AppTheme.darkThemeMode,
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => const MyHomePage(),
      //   '/signup': (context) => const SignUpPage(),
      //   '/login': (context) => const LoginPage(),
      // },
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
      selector: (state) {
        return state is AppUserLoggedIn;
      },
      builder: (context, isLoggedIn) {
        if (isLoggedIn) {
          return const MyHomePage();
        }
        return const LoginPage();
      },
    ),
    );
  }
}
