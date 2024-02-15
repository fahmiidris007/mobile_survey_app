// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile_survey_app/provider/auth_provider.dart';
import 'package:mobile_survey_app/theme/style.dart';
import 'package:provider/provider.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.formKey,
    required this.nikController,
    required this.passwordController,
    required bool rememberMe,
  }) : _rememberMe = rememberMe;

  final GlobalKey<FormState> formKey;
  final TextEditingController nikController;
  final TextEditingController passwordController;
  final bool _rememberMe;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          final nik = nikController.text;
          final password = passwordController.text;
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          await authProvider.login(nik, password, _rememberMe);
          final state = authProvider.state;
          if (state == ResultState.loading) {
            const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state == ResultState.success) {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authProvider.message),
              ),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size.fromWidth(300),
        backgroundColor: secondaryColor,
        foregroundColor: primaryColor,
        textStyle: myTextTheme.titleSmall,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
      ),
      child: const Text(
        'Log in',
      ),
    );
  }
}
