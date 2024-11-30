import 'package:account_management_app/blocs/auth/auth_bloc.dart';
import 'package:account_management_app/utils/constants.dart';
import 'package:account_management_app/widgets/app_textfield.dart';
import 'package:account_management_app/widgets/extensions.dart';
import 'package:account_management_app/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/global_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, authState) {
          if (authState is Authenticated) {
            showToast(context, "Logged In!");
            Navigator.pushNamedAndRemoveUntil(
                context, Constants.SCR_PROFILE, (_) => false);
          } else if (authState is AuthError) {
            showToast(context, authState.message);
          }
        },
        builder: (context, state) {
          return state is AuthLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppTextfield(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const Gap(16),
                      AppTextfield(
                        controller: _passwordController,
                        label: 'Password',
                        isPassword: true,
                      ),
                      const Gap(16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            context.read<AuthBloc>().add(
                                  LoginRequested(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                          }
                        },
                        child: const Text('Login'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Constants.SCR_REGISTER);
                        },
                        child: const Text('Create Account'),
                      ),
                    ],
                  ),
                ).padAll(16);
        },
      ),
    );
  }
}
