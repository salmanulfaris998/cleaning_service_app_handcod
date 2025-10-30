class CleaningService {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double rating;
  final int orders;
  final int duration;

  const CleaningService({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.orders,
    required this.duration,
  });
}
