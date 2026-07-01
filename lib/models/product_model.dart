class ProductModel {
  const ProductModel({
    required this.name,
    required this.weight,
    required this.priceInt,
    required this.priceDec,
    required this.image,
    this.cartCount = 0,
  });

  /// ProductModel name.
  final String name;

  /// Weight or quantity.
  final String weight;

  /// Integer part of the price.
  final String priceInt;

  /// Decimal part of the price.
  final String priceDec;

  /// Asset image path.
  final String image;

  /// Initial quantity in the cart.
  final int cartCount;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] as String,
      weight: json['weight'] as String,
      priceInt: json['priceInt'] as String,
      priceDec: json['priceDec'] as String,
      image: json['image'] as String,
      cartCount: json['cartCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'weight': weight,
      'priceInt': priceInt,
      'priceDec': priceDec,
      'image': image,
      'cartCount': cartCount,
    };
  }

  ProductModel copyWith({
    String? name,
    String? weight,
    String? priceInt,
    String? priceDec,
    String? image,
    int? cartCount,
  }) {
    return ProductModel(
      name: name ?? this.name,
      weight: weight ?? this.weight,
      priceInt: priceInt ?? this.priceInt,
      priceDec: priceDec ?? this.priceDec,
      image: image ?? this.image,
      cartCount: cartCount ?? this.cartCount,
    );
  }
}
const productsData=  [
      {
        'name': 'Beetroot\n(Local shop)',
        'weight': '500 gm.',
        'priceInt': '17',
        'priceDec': '.29\$',
        'image': 'assets/images/beetroots.png',
        'initialCount': 0,
      },
      {
        'name': 'Italian Avocado\n(Local shop)',
        'weight': '450 gm.',
        'priceInt': '14',
        'priceDec': '.29\$',
        'image': 'assets/images/avocado.png',
        'initialCount': 1,
      },
      {
        'name': 'Deshi Gajor\n(Local Carrot)',
        'weight': '1000 gm.',
        'priceInt': '27',
        'priceDec': '.29\$',
        'image': 'assets/images/carrots.png',
        'initialCount': 0,
      },
    ];

    final productsList= productsData.map((e) => ProductModel.fromJson(e)).toList();