class CoffeeModel {
  final Shop shop;
  final List<Category> categories;
  final List<Product> products;

  CoffeeModel({
    required this.shop,
    required this.categories,
    required this.products,
  });

  factory CoffeeModel.fromJson(Map<String, dynamic> json) {
    return CoffeeModel(
      shop: Shop.fromJson(json['shop']),
      categories: (json['categories'] as List)
          .map((e) => Category.fromJson(e))
          .toList(),
      products: (json['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }
}

class Shop {
  final String name;
  final String location;
  final double rating;

  Shop({required this.name, required this.location, required this.rating});

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      name: json['name'],
      location: json['location'],
      rating: json['rating'].toDouble(),
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int categoryId;
  final String image;
  final double rating;
  final bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.image,
    required this.rating,
    required this.isFavorite,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      categoryId: json['category_id'],
      image: json['image'],
      rating: json['rating'].toDouble(),
      isFavorite: json['is_favorite'],
    );
  }
}