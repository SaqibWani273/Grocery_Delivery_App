import 'package:flutter/material.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/models/store_model.dart';
import 'package:grocery_delivery_app/product_details/product_details_provider.dart';
import 'package:grocery_delivery_app/product_details/widgets/choose_store_sheet.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';
import 'package:provider/provider.dart';


/// "Others store" list — the same product offered by nearby stores,
/// with one offer selectable at a time.
class OthersStoreSection extends StatelessWidget {
  final List<StoreOffer> offers;

  const OthersStoreSection({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    final details = context.watch<ProductDetailsProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Others store',
              style: context.textTheme.titleLarge?.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            TextButton(
              onPressed: () => showChooseStoreSheet(context),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: const Text(
                'Visit stores',
                style: TextStyle(
                  color: AppColors.textAccentOrange,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        for (int i = 0; i < offers.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: StoreOfferCard(
              offer: offers[i],
              selected: details.selectedStoreIndex == i,
              onTap: () => details.selectStore(i),
            ),
          ),
      ],
    );
  }
}

class StoreOfferCard extends StatelessWidget {
  final StoreOffer offer;
  final bool selected;
  final VoidCallback onTap;

  const StoreOfferCard({
    super.key,
    required this.offer,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? AppColors.accentLightTint : const Color(0xFFF4F5F5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primaryAccent : Colors.transparent,
            width: 1.4,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  _buildLogo(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer.name,
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.bolt,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 2),
                            Text(
                              'Delivery in ${offer.deliveryMinutes} minute',
                              style: const TextStyle(
                                color: AppColors.textSecondaryGrey,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${offer.priceInt}${offer.priceDec}',
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (offer.badgeLabel != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: const BoxDecoration(
                    color: AppColors.storePurple,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                    ),
                  ),
                  child: Text(
                    offer.badgeLabel!,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            if (offer.deliveryFee != null)
              Positioned(
                bottom: 14,
                right: 14,
                child: Text(
                  offer.deliveryFee!,
                  style: const TextStyle(
                    color: AppColors.textSecondaryGrey,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    if (offer.logoPath != null) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage(offer.logoPath!),
      );
    }

    // No logo asset available — fall back to a lettered avatar.
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.white,
      child: Text(
        offer.name[0],
        style: const TextStyle(
          color: AppColors.textAccentOrange,
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    );
  }
}
