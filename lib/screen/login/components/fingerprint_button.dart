// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile_survey_app/theme/style.dart';

class FingerprintButton extends StatelessWidget {
  const FingerprintButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        fixedSize: const Size.fromWidth(300),
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
        textStyle: myTextTheme.titleSmall,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: secondaryColor),
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
      ),
      child: const Text(
        'Fingerprint',
      ),
    );
  }
}
