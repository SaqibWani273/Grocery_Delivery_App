import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/dashboard/widgets/custom_shapes.dart';
import 'package:grocery_delivery_app/models/store_model.dart';
import 'package:grocery_delivery_app/product_details/product_details_provider.dart';
import 'package:grocery_delivery_app/store_profile/store_profile_screen.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';
import 'package:provider/provider.dart';

/// Opens the "Choose store" sheet. The sheet lives on its own route, so
/// the details screen's provider is re-exposed to it explicitly.
void showChooseStoreSheet(BuildContext context) {
  final detailsProvider = context.read<ProductDetailsProvider>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ChangeNotifierProvider.value(
      value: detailsProvider,
      child: const ChooseStoreSheet(offers: demoChooseStoreOffers),
    ),
  );
}

class ChooseStoreSheet extends StatelessWidget {
  final List<StoreOffer> offers;

  const ChooseStoreSheet({super.key, required this.offers});

  static const _domeDrop = 26.0;

  @override
  Widget build(BuildContext context) {
    final details = context.watch<ProductDetailsProvider>();

    return FractionallySizedBox(
      heightFactor: 0.88,
      child: ClipPath(
        clipper: TopDomeCurve(drop: _domeDrop),
        child: Container(
          color: AppColors.cardBackground,
          child: Column(
            children: [
              const SizedBox(height: 14),
              const DragHandleArc(),
              const SizedBox(height: 20),
              Text(
                'Choose store',
                style: context.textTheme.titleLarge?.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    24,
                  ),
                  itemCount: offers.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _StoreListTile(
                      offer: offers[index],
                      selected: details.selectedStoreIndex == index,
                      onTap: () {
                        details.selectStore(index);
                        Navigator.push(
                          context,
                          StoreProfileScreen.route(offer: offers[index]),
                        );
                      },
                    )
                        .animate(delay: (50 * index).ms)
                        .fadeIn(duration: 300.ms, curve: Curves.easeIn)
                        .slideY(
                          begin: 0.2,
                          end: 0,
                          duration: 300.ms,
                          curve: Curves.easeOut,
                        );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoreListTile extends StatelessWidget {
  final StoreOffer offer;
  final bool selected;
  final VoidCallback onTap;

  const _StoreListTile({
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
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentLightTint : const Color(0xFFF4F5F5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primaryAccent : Colors.transparent,
            width: 1.4,
          ),
        ),
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
                      const Icon(Icons.bolt, color: Colors.amber, size: 16),
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
                  if (offer.stockLabel != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      offer.stockLabel!,
                      style: const TextStyle(
                        color: Color(0xFFD32F2F),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondaryGrey,
              size: 26,
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
