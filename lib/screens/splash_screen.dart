import 'package:account_management_app/repositories/auth_repository.dart';
import 'package:account_management_app/widgets/extensions.dart';
import 'package:account_management_app/widgets/gap.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkNavigation();
  }

  Future<void> checkNavigation() async {
    await Future.delayed(2.second);
    AuthRepository auth = AuthRepository();
    final isLoggedIn = await auth.isUserLoggedIn();
    if (!mounted) return;
    if (isLoggedIn) {
      Navigator.pushNamedAndRemoveUntil(
          context, Constants.SCR_PROFILE, (_) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, Constants.SCR_LOGIN, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome!",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Gap(32),
            const LinearProgressIndicator(),
          ],
        ).padXX16,
      ),
    );
  }
}
