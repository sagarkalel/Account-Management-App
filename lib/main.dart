import 'package:account_management_app/repositories/auth_repository.dart';
import 'package:account_management_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/auth/auth_bloc.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'utils/constants.dart';

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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.opaque,
      child: RepositoryProvider(
        create: (context) => AuthRepository(),
        child: BlocProvider(
          create: (context) => AuthBloc(authRepository: AuthRepository()),
          child: MaterialApp(
            title: 'Account Management',
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData.dark().copyWith(
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
            themeMode: ThemeMode.dark,
            initialRoute: Constants.SCR_SPLASH,
            routes: {
              Constants.SCR_SPLASH: (_) => const SplashScreen(),
              Constants.SCR_LOGIN: (_) => const LoginScreen(),
              Constants.SCR_REGISTER: (_) => const RegisterScreen(),
              Constants.SCR_PROFILE: (_) => const ProfileScreen(),
            },
          ),
        ),
      ),
    );
  }
}
