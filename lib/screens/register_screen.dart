import 'dart:io';

import 'package:account_management_app/blocs/auth/auth_bloc.dart';
import 'package:account_management_app/utils/constants.dart';
import 'package:account_management_app/widgets/gap.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../repositories/global_services.dart';
import '../widgets/app_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  File? _profilePhoto;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePhoto = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            showToast(context, "Account Created Successfully!");
            Navigator.pushNamedAndRemoveUntil(
                context, Constants.SCR_PROFILE, (_) => false);
          } else if (state is AuthError) {
            showToast(context, state.message);
          }
        },
        builder: (context, state) {
          return state is AuthLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _profilePhoto != null
                                ? FileImage(_profilePhoto!)
                                : null,
                            child: _profilePhoto == null
                                ? const Icon(Icons.add_a_photo, size: 40)
                                : null,
                          ),
                        ),
                        const Gap(16),
                        AppTextfield(
                            controller: _firstNameController,
                            label: 'First Name'),
                        const Gap(16),
                        AppTextfield(
                            controller: _lastNameController,
                            label: 'Last Name'),
                        const Gap(16),
                        AppTextfield(
                          controller: _mobileController,
                          label: 'Mobile Number',
                          keyboardType: TextInputType.phone,
                        ),
                        const Gap(16),
                        AppTextfield(
                          controller: _emailController,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              !EmailValidator.validate(value ?? '')
                                  ? 'Invalid email'
                                  : null,
                        ),
                        const Gap(16),
                        AppTextfield(
                          controller: _passwordController,
                          label: 'Password',
                          isPassword: true,
                        ),
                        const Gap(16),
                        AppTextfield(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          isPassword: true,
                          validator: (value) =>
                              value != _passwordController.text
                                  ? 'Passwords do not match'
                                  : null,
                        ),
                        const Gap(16),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<AuthBloc>().add(
                                    RegisterRequested(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      mobile: _mobileController.text,
                                      profilePhoto: _profilePhoto,
                                    ),
                                  );
                            }
                          },
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
