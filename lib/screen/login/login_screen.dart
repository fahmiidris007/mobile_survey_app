import 'package:flutter/material.dart';
import 'package:mobile_survey_app/provider/auth_provider.dart';
import 'package:mobile_survey_app/screen/home/home_screen.dart';
import 'package:mobile_survey_app/theme/style.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final nikController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final user = await Provider.of<AuthProvider>(context, listen: false).authRepository.getUser();
      if (user != null) {
        nikController.text = user.nik;
        passwordController.text = user.password;
        _rememberMe = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(key: formKey, child: _buildForm(context)),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Login to Synapsis',
          style: myTextTheme.titleLarge,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 32),
        Text(
          'NIK',
          style: myTextTheme.bodyMedium?.copyWith(color: labelColor),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: nikController,
          decoration: InputDecoration(
              labelText: 'NIK',
              labelStyle: myTextTheme.bodyMedium?.copyWith(color: hintColor),
              constraints: const BoxConstraints(maxHeight: 40),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              )),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'NIK is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Password',
          style: myTextTheme.bodyMedium?.copyWith(color: labelColor),
        ),
        TextFormField(
          controller: passwordController,
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: myTextTheme.bodyMedium?.copyWith(color: hintColor),
            constraints: const BoxConstraints(maxHeight: 40),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            return null;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                }),
            const Text(
              'Remember me',
              style: TextStyle(color: hintColor),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text('Error \n${authProvider.message}'),
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
                  Radius.circular(0),
                ),
              ),
            ),
            child: const Text(
              'Log in',
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text("Or",
              style: myTextTheme.labelLarge?.copyWith(color: secondaryColor)),
        ),
        const SizedBox(height: 8),
        Center(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromWidth(300),
              backgroundColor: primaryColor,
              foregroundColor: secondaryColor,
              textStyle: myTextTheme.titleSmall,
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: secondaryColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
              ),
            ),
            child: const Text(
              'Fingerprint',
            ),
          ),
        ),
      ],
    );
  }
}
