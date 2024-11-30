import 'package:flutter/material.dart';

class AppTextfield extends StatelessWidget {
  const AppTextfield({
    super.key,
    required this.controller,
    required this.label,
    this.defaultValidator = true,
    this.validator,
    this.isPassword = false,
    this.keyboardType,
  });
  final TextEditingController controller;
  final String label;
  final bool defaultValidator;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      validator: validator ??
          ((value) => value?.isEmpty ?? true ? 'Required field' : null),
    );
  }
}
