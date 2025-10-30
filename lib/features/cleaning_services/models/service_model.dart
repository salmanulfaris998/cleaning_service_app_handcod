class ServiceModel {
  final String id;
  final String image;
  final String title;
  final String duration;
  final double price;
  final double rating;
  final int orders;

  const ServiceModel({
    required this.id,
    required this.image,
    required this.title,
    required this.duration,
    required this.price,
    required this.rating,
    required this.orders,
  });
}
