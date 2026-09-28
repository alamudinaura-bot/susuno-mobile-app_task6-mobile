import 'package:flutter/material.dart';

/// SUSUNO logo lockup from the Figma login design:
/// a white rounded tile with the box icon, and below it the "SUSUN"
/// wordmark followed by a small box icon that plays the role of the "O".
class SusunoLogo extends StatelessWidget {
  const SusunoLogo({super.key, this.scale = 1});

  /// Scales the whole lockup (1 = login page size).
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64 * scale,
          height: 64 * scale,
          padding: EdgeInsets.all(10 * scale),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16 * scale),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10 * scale,
              ),
            ],
          ),
          child: Image.asset('assets/images/logo_box.png', fit: BoxFit.contain),
        ),
        SizedBox(height: 8 * scale),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_text.png',
              height: 24 * scale,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 2 * scale),
            Image.asset(
              'assets/images/logo_box.png',
              height: 26 * scale,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ],
    );
  }
}
