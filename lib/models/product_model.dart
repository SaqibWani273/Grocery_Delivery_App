import 'package:grocery_delivery_app/models/store_model.dart';

class ProductModel {
  const ProductModel({
    required this.name,
    required this.weight,
    required this.priceInt,
    required this.priceDec,
    required this.image,
    this.cartCount = 0,
    this.description = _demoDescription,
    this.rating = '4.5',
    this.cookingIdea = _demoCookingIdea,
    this.nutritionValues = _demoNutritionValues,
    this.storeOffers = demoStoreOffers,
    this.isFavorite = false,
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

  /// Long description shown on the details screen.
  final String description;

  /// Average rating, e.g. '4.5'.
  final String rating;

  /// Body text of the 'Cooking idea' section.
  final String cookingIdea;

  /// Body text of the 'Nutrition values' section.
  final String nutritionValues;

  /// Offers from other stores (in-memory demo data, not serialized).
  final List<StoreOffer> storeOffers;

  final bool isFavorite;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] as String,
      weight: json['weight'] as String,
      priceInt: json['priceInt'] as String,
      priceDec: json['priceDec'] as String,
      image: json['image'] as String,
      cartCount: json['cartCount'] as int? ?? 0,
      description: json['description'] as String? ?? _demoDescription,
      rating: json['rating'] as String? ?? '4.5',
      cookingIdea: json['cookingIdea'] as String? ?? _demoCookingIdea,
      nutritionValues: json['nutritionValues'] as String? ?? _demoNutritionValues,
      isFavorite: json['isFavorite'] as bool? ?? false,
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
      'description': description,
      'rating': rating,
      'cookingIdea': cookingIdea,
      'nutritionValues': nutritionValues,
      'isFavorite': isFavorite,
    };
  }

  ProductModel copyWith({
    String? name,
    String? weight,
    String? priceInt,
    String? priceDec,
    String? image,
    int? cartCount,
    String? description,
    String? rating,
    String? cookingIdea,
    String? nutritionValues,
    List<StoreOffer>? storeOffers,
    bool? isFavorite,
  }) {
    return ProductModel(
      name: name ?? this.name,
      weight: weight ?? this.weight,
      priceInt: priceInt ?? this.priceInt,
      priceDec: priceDec ?? this.priceDec,
      image: image ?? this.image,
      cartCount: cartCount ?? this.cartCount,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      cookingIdea: cookingIdea ?? this.cookingIdea,
      nutritionValues: nutritionValues ?? this.nutritionValues,
      storeOffers: storeOffers ?? this.storeOffers,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

const _demoDescription =
    '100% satisfaction guarantee. If you experience any of the following '
    'issues, missing, poor item, late arrival, unprofessional service, or '
    'any other problem, we will refund the full price of the affected item. '
    'Your happiness is our top priority.';

const _demoCookingIdea =
    'Sear the cuts on high heat to lock in the juices, then slow-cook with '
    'root vegetables and fresh herbs for a rich, tender stew.';

const _demoNutritionValues =
    'Per 100 gm: Energy 250 kcal, Protein 26 gm, Fat 15 gm, '
    'Carbohydrates 0 gm, Iron 2.6 mg, Zinc 6.3 mg.';
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
        'initialCount': 0,
      },
       {
        'name': 'Fresh Lemon\n(Local shop)',
        'weight': '500 gm.',
        'priceInt': '10',
        'priceDec': '.29\$',
        'image': 'assets/images/lemon.png',
        'initialCount': 0,
        
      },
      {
        'name': 'Deshi Gajor\n(Local Carrot)',
        'weight': '1000 gm.',
        'priceInt': '27',
        'priceDec': '.29\$',
        'image': 'assets/images/carrots.png',
        'initialCount': 0,
      },
      {
        'name': 'Fresh Broccoli\n(Local shop)',
        'weight': '500 gm.',
        'priceInt': '19',
        'priceDec': '.29\$',
        'image': 'assets/images/broccoli.png',
        'initialCount': 0,
      },
     
      {
        'name': 'Sprite\n(Local shop)',
        'weight': '500 ml.',
        'priceInt': '5',
        'priceDec': '.29\$',
        'image': 'assets/images/sprite.png',
        'initialCount': 0,
      },
      {
        'name': 'Fresh Tomato\n(Local shop)',
        'weight': '500 gm.',
        'priceInt': '15',
        'priceDec': '.29\$',
        'image': 'assets/images/tomato.png',
        'initialCount': 0,
      },
       {
        'name': 'Fresh Meat\n(Local shop)',
        'weight': '500 gm.',
        'priceInt': '15',
        'priceDec': '.29\$',
        'image': 'assets/images/beef.png',
        'initialCount': 0,
      },
       {
        'name': 'Fresh Cucumber\n(Local shop)',
        'weight': '500 gm.',
        'priceInt': '12',
        'priceDec': '.29\$',
        'image': 'assets/images/cucumber.png',
        'initialCount': 0,
      },
      //repeating items for testing
       {
        'name': 'Beetroot\n(Local shop)',
        'weight': '500 gm.',
        'priceInt': '17',
        'priceDec': '.29\$',
        'image': 'assets/images/beetroots.png',
        'initialCount': 0,
      },
      {
        'name': 'Sprite\n(Local shop)',
        'weight': '500 ml.',
        'priceInt': '5',
        'priceDec': '.29\$',
        'image': 'assets/images/sprite.png',
        'initialCount': 0,
      },
       {
        'name': 'Fresh Lemon\n(Local shop)',
        'weight': '500 gm.',
        'priceInt': '10',
        'priceDec': '.29\$',
        'image': 'assets/images/lemon.png',
        'initialCount': 0,
        
      },
      {
        'name': 'Fresh Cucumber\n(Local shop)',
        'weight': '500 gm.',
        'priceInt': '12',
        'priceDec': '.29\$',
        'image': 'assets/images/cucumber.png',
        'initialCount': 0,
      },
     
    ];

    final productsList= productsData.map((e) => ProductModel.fromJson(e)).toList();