import 'package:flutter/material.dart';
import 'package:mobile_survey_app/data/api/api_service.dart';
import 'package:mobile_survey_app/data/db/auth_repository.dart';
import 'package:mobile_survey_app/provider/auth_provider.dart';
import 'package:mobile_survey_app/provider/survey_provider.dart';
import 'package:mobile_survey_app/screen/home/home_screen.dart';
import 'package:mobile_survey_app/screen/login/login_screen.dart';
import 'package:mobile_survey_app/theme/style.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authRepository = AuthRepository();
  final apiService = ApiService();
  final authProvider = AuthProvider(authRepository, apiService);
  final autoLoginSuccess = await authProvider.autoLogin();

  runApp(MyApp(
    initialRoute: autoLoginSuccess ? '/home' : '/login',
    authProvider: authProvider,
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final AuthProvider authProvider;

  const MyApp(
      {super.key, required this.initialRoute, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            AuthRepository(),
            ApiService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SurveyProvider(
            ApiService(),
            AuthRepository(),
          ),
        )
      ],
      child: MaterialApp(
        title: 'Mobile Survey App',
        theme: ThemeData(
          textTheme: myTextTheme,
        ),
        initialRoute: initialRoute,
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
