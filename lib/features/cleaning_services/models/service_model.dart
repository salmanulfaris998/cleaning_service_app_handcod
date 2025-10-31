class ServiceModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int durationMins;
  final double rating;
  final int ordersCount;
  final String imageUrl;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.durationMins,
    required this.rating,
    required this.ordersCount,
    required this.imageUrl,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      durationMins: json['duration_mins'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ordersCount: json['orders_count'] ?? 0,
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'duration_mins': durationMins,
      'rating': rating,
      'orders_count': ordersCount,
      'image_url': imageUrl,
    };
  }
}
