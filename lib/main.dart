import 'package:flutter/material.dart';
import 'package:mobile_survey_app/data/api/api_service.dart';
import 'package:mobile_survey_app/data/db/auth_repository.dart';
import 'package:mobile_survey_app/provider/auth_provider.dart';
import 'package:mobile_survey_app/theme/style.dart';
import 'package:mobile_survey_app/screen/login/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(AuthRepository(), ApiService()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: myTextTheme,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
