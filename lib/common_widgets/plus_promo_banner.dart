import 'package:flutter/material.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';

/// "Plus+" promotional banner used on the store profile (navy) and the
/// categories screen (rust). Only the background color changes.
class PlusPromoBanner extends StatelessWidget {
  final Color background;

  const PlusPromoBanner({super.key, required this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [background.lighten(0.04), background.darken(0.05)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Get 10% off groceries with Plus+ T&C Apply',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.white.withAlpha(180),
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Spend \$30.00 to get 5%',
                style: TextStyle(
                  color: Colors.white.withAlpha(180),
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
