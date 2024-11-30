import 'dart:io';

import 'package:account_management_app/blocs/auth/auth_bloc.dart';
import 'package:account_management_app/repositories/auth_repository.dart';
import 'package:account_management_app/utils/constants.dart';
import 'package:account_management_app/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_model.dart';
import '../repositories/global_services.dart';
import '../widgets/app_textfield.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  File? _newProfilePhoto;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    user = await AuthRepository().getUser();
    _firstNameController = TextEditingController(text: user?.firstName);
    _lastNameController = TextEditingController(text: user?.lastName);
    _mobileController = TextEditingController(text: user?.mobile);
    setState(() {});
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _newProfilePhoto = File(pickedFile.path);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          showToast(context, state.message);
        } else if (state is AuthUpdated) {
          showToast(context, "Account Successfully Updated!");
        } else if (state is AuthLogoutDone) {
          showToast(context, "Logged Out!");
          Navigator.pushNamedAndRemoveUntil(
              context, Constants.SCR_SPLASH, (_) => false);
        } else if (state is AuthAccountDeleted) {
          showToast(context, "Account Deleted Successfully!");
          Navigator.pushNamedAndRemoveUntil(
              context, Constants.SCR_SPLASH, (_) => false);
        }
      },
      builder: (context, state) {
        final bloc = context.read<AuthBloc>();
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  final result = await _showConfirmationDialog('Logout');
                  if (result) bloc.add(LogoutRequested());
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _newProfilePhoto != null
                          ? FileImage(_newProfilePhoto!)
                          : (user?.profilePhotoUrl != null
                              ? NetworkImage(user!.profilePhotoUrl!)
                              : null) as ImageProvider?,
                      child: (_newProfilePhoto == null &&
                              user?.profilePhotoUrl == null)
                          ? const Icon(Icons.add_a_photo, size: 40)
                          : null,
                    ),
                  ),
                  const Gap(32),
                  AppTextfield(
                      controller: _firstNameController, label: 'First Name'),
                  const Gap(16),
                  AppTextfield(
                      controller: _lastNameController, label: 'Last Name'),
                  const Gap(16),
                  AppTextfield(
                    controller: _mobileController,
                    label: 'Mobile Number',
                    keyboardType: TextInputType.phone,
                  ),
                  const Gap(32),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final userModel = user?.copyWith(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          mobile: _mobileController.text,
                        );
                        bloc.add(
                          UpdateUserRequested(
                            user: userModel,
                            newProfilePhoto: _newProfilePhoto,
                          ),
                        );
                      }
                    },
                    child: const Text('Update Profile'),
                  ),
                  const Gap(16),
                  ElevatedButton(
                    onPressed: () async {
                      final result =
                          await _showConfirmationDialog('Delete Account');
                      if (result) bloc.add(DeleteUserRequested());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete Account'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _showConfirmationDialog(String action) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: Text('Confirm $action'),
            content: Text('Are you sure you want to $action?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(action),
              ),
            ],
          ),
        ) ??
        false;
  }
}
