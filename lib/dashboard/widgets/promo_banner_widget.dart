import 'package:flutter/material.dart';
import 'package:grocery_delivery_app/app_sizes.dart';

import '../../app_colors.dart';
import '../../ui_extensions.dart';


class PromoBannerConfig {
  final String title;
  final String time;
  final Color backgroundColor;
  final Color textColor;
  final String imagePath;

  const PromoBannerConfig({
    required this.title,
    required this.time,
    required this.backgroundColor,
    required this.textColor,
    required this.imagePath,
  });
}

class PromoBannersRow extends StatelessWidget {
  const PromoBannersRow({super.key});

  @override
  Widget build(BuildContext context) {
    // Strongly typed list using our local configurations
    final List<PromoBannerConfig> banners = [
      const PromoBannerConfig(
        title: 'Grocery',
        time: 'By 12:15pm',
        backgroundColor: AppColors.groceryBannerBg,
        textColor: AppColors.groceryBannerText,
        imagePath: 'assets/images/avocado.png',
      ),
      const PromoBannerConfig(
        title: 'Wholesale',
        time: 'By 1:30pm',
        backgroundColor: AppColors.wholesaleBannerBg,
        textColor: AppColors.wholesaleBannerText,
        imagePath: 'assets/images/beetroots.png',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(left: AppSizes.dashboardLeftPadding),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: banners.map((config) {
            return Padding(
              padding: EdgeInsets.only(
                right: config == banners.first ? 4.0 : 0.0,
                left: config == banners.last ? 4.0 : 0.0,
              ),
              child: _buildBannerCard(context, config),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBannerCard(BuildContext context, PromoBannerConfig config) {
    return Container(
      height: 110,
      
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 12.0, bottom: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  config.title,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: config.textColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  config.time,
                  style: TextStyle(
                    color: config.textColor.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Free delivery',
                  style: TextStyle(
                    color: config.textColor.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
SizedBox(width: 12),
            Container(
              // width: 120,
              // height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: config.textColor.withOpacity(0.04),
              ),
              child:
               Image.asset(
              config.imagePath,
              width: 80,
              height: 80,
              // fit: BoxFit.contain,
            ),
            ),
          ],
        ),
      ),
    );
  }
}