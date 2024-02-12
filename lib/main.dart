import 'package:flutter/material.dart';
import 'package:mobile_survey_app/theme/style.dart';
import 'package:mobile_survey_app/ui/screen/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: myTextTheme,
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //   style: ElevatedButton.styleFrom(
        //     fixedSize: const Size.fromWidth(300),
        //     backgroundColor: secondaryColor,
        //     foregroundColor: Colors.white,
        //     textStyle: myTextTheme.titleSmall,
        //     shape: const RoundedRectangleBorder(
        //       borderRadius: BorderRadius.all(
        //         Radius.circular(0),
        //       ),
        //     ),
        //   ),
        // ),
      ),
      home: const LoginScreen(),
    );
  }
}
