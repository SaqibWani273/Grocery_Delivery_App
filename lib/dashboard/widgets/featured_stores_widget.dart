

import 'package:flutter/material.dart';
import 'package:grocery_delivery_app/app_sizes.dart';

import '../../app_colors.dart';
import '../../models/store_model.dart';
import '../../ui_extensions.dart';

class FeaturedStoreSection extends StatelessWidget {
  const FeaturedStoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Clean, immutable strongly typed data objects
    final List<StoreModel> stores = [
      const StoreModel(
        name: 'T&T Food Market',
        deliveryTime: 'In 12 minute',
        logoPath: 'assets/images/store1.png',
      ),
      const StoreModel(
        name: 'Shoppers drug mart',
        deliveryTime: 'In 12 minute',
        logoPath: 'assets/images/store0.png',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSizes.dashboardLeftPadding, right: 20.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Featured store',
                style: context.textTheme.titleLarge?.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              GestureDetector(
                child: const Text(
                    'See all',
                    style: TextStyle(
                      color: AppColors.textAccentOrange,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: AppSizes.dashboardLeftPadding),
            itemCount: stores.length,
            itemBuilder: (context, index) {
              final store = stores[index]; // Complete autocomplete features enabled here
              return Container(
                width: context.deviceWidth * 0.46,
                margin: const EdgeInsets.only(right: 14.0, bottom: 8.0),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      child: Container(
                        height: 75,
                        color: AppColors.primaryDark,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              child: CustomPaint(
                                size: const Size(double.infinity, 36),
                                painter: AwningPainter(),
                              ),
                            ),
                            Positioned(
                              left: 12,
                              bottom: 8,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: ClipOval(
                                  child: Image.asset(store.logoPath, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.bolt, color: Colors.amber, size: 16),
                              const SizedBox(width: 2),
                              Text(
                                store.deliveryTime,
                                style: const TextStyle(
                                  color: AppColors.textSecondaryGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AwningPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // The paint brush configuration
    final paint = Paint()
      ..color = const Color(0xFFFCEECC) // The cream/yellow scalloped roof color from the UI
      ..style = PaintingStyle.fill;

    final path = Path();
    path.lineTo(0, size.height - 10);

    // This dynamically splits the card width into 5 equal parts
    double baseWidth = size.width;
    int scallopCount = 5; 
    double waveWidth = baseWidth / scallopCount;

    // Loop across the width to draw the repeating U-shape arches programmatically
    for (int i = 0; i < scallopCount; i++) {
      double startX = i * waveWidth;
      path.quadraticBezierTo(
        startX + (waveWidth / 2), // Horizontal center of the wave
        size.height + 6,          // Pulls the curve down to create the depth of the arc
        startX + waveWidth,       // End point of this specific wave segment
        size.height - 10,
      );
    }

    path.lineTo(size.width, 0);
    path.close();
    
    // Draw the completed shape path onto the card's canvas surface
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}