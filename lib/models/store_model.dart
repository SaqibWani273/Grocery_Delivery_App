class StoreModel {
  final String name;
  final String deliveryTime;
  final String logoPath;

  const StoreModel({
    required this.name,
    required this.deliveryTime,
    required this.logoPath,
  });
}

/// A store's offer for a product, shown under "Others store" on the
/// product details screen and in the "Choose store" sheet.
class StoreOffer {
  final String name;

  /// Circular logo asset. Null means no logo available — the card falls
  /// back to a lettered avatar.
  final String? logoPath;

  final int deliveryMinutes;

  /// Price split like [ProductModel] for the superscript-cents style.
  final String priceInt;
  final String priceDec;

  /// Corner pill label, e.g. 'Lower price' or 'In Store price'.
  final String? badgeLabel;

  /// Extra delivery charge, e.g. '+4.90 Delivery'.
  final String? deliveryFee;

  /// Availability warning shown in red, e.g. 'Out of stock'.
  final String? stockLabel;

  /// Category line on the store profile screen.
  final String tags;

  const StoreOffer({
    required this.name,
    this.logoPath,
    required this.deliveryMinutes,
    required this.priceInt,
    required this.priceDec,
    this.badgeLabel,
    this.deliveryFee,
    this.stockLabel,
    this.tags = 'Vegetable • Superfood • Grocery',
  });
}

const demoStoreOffers = [
  StoreOffer(
    name: 'M&M Food Market',
    logoPath: 'assets/images/store0.png',
    deliveryMinutes: 12,
    priceInt: '20',
    priceDec: '.42\$',
  ),
  StoreOffer(
    name: 'T&T Food Market',
    logoPath: 'assets/images/store1.png',
    deliveryMinutes: 13,
    priceInt: '19',
    priceDec: '.50\$',
    badgeLabel: 'Lower price',
    deliveryFee: '+4.90 Delivery',
  ),
  StoreOffer(
    name: 'Loblaws',
    deliveryMinutes: 15,
    priceInt: '23',
    priceDec: '.00\$',
    badgeLabel: 'In Store price',
    deliveryFee: '+3.90 Delivery',
  ),
];

/// Longer list backing the "Choose store" sheet. Starts with the same
/// stores as [demoStoreOffers] so the selection index stays in sync.
const demoChooseStoreOffers = [
  StoreOffer(
    name: 'M&M Food Market',
    logoPath: 'assets/images/store0.png',
    deliveryMinutes: 12,
    priceInt: '20',
    priceDec: '.42\$',
  ),
  StoreOffer(
    name: 'T&T Food Market',
    logoPath: 'assets/images/store1.png',
    deliveryMinutes: 13,
    priceInt: '19',
    priceDec: '.50\$',
  ),
  StoreOffer(
    name: 'Loblaws',
    deliveryMinutes: 15,
    priceInt: '23',
    priceDec: '.00\$',
    stockLabel: 'Only 2 kg available',
  ),
  StoreOffer(
    name: 'Shoppers',
    deliveryMinutes: 15,
    priceInt: '23',
    priceDec: '.00\$',
    stockLabel: 'Out of stock',
  ),
  StoreOffer(
    name: 'Walmart grocery',
    deliveryMinutes: 15,
    priceInt: '23',
    priceDec: '.00\$',
  ),
  StoreOffer(
    name: 'M&M Food Market',
    logoPath: 'assets/images/store0.png',
    deliveryMinutes: 12,
    priceInt: '20',
    priceDec: '.42\$',
  ),
];