import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancod_machine_test/features/cart/controller/cart_controller.dart';
import 'package:hancod_machine_test/features/cleaning_services/models/cleaning_service.dart';

const cleaningCategories = [
  'Deep cleaning',
  'Maid Services',
  'Car Cleaning',
  'Carpet Cleaning',
];

final Map<String, List<CleaningService>> cleaningServicesByCategory = {
  'Deep cleaning': const [
    CleaningService(
      id: 'dc-1',
      name: 'Full Home Deep Clean',
      imageUrl: 'assets/services_images/home_cleaning.png',
      price: 2499.0,
      rating: 4.7,
      orders: 54,
      duration: 240,
    ),
    CleaningService(
      id: 'dc-2',
      name: 'Kitchen Degrease & Sanitize',
      imageUrl: 'assets/services_images/home_cleaning.png',
      price: 1299.0,
      rating: 4.5,
      orders: 38,
      duration: 150,
    ),
  ],
  'Maid Services': const [
    CleaningService(
      id: 'ms-1',
      name: 'Daily Maid Service',
      imageUrl: 'assets/services_images/home_cleaning.png',
      price: 799.0,
      rating: 4.3,
      orders: 112,
      duration: 120,
    ),
    CleaningService(
      id: 'ms-2',
      name: 'Weekly Deep Maid',
      imageUrl: 'assets/services_images/home_cleaning.png',
      price: 999.0,
      rating: 4.4,
      orders: 64,
      duration: 180,
    ),
  ],
  'Car Cleaning': const [
    CleaningService(
      id: 'cc-1',
      name: 'Interior Detailing',
      imageUrl: 'assets/services_images/home_cleaning.png',
      price: 599.0,
      rating: 4.6,
      orders: 82,
      duration: 90,
    ),
    CleaningService(
      id: 'cc-2',
      name: 'Exterior Wash & Wax',
      imageUrl: 'assets/services_images/home_cleaning.png',
      price: 499.0,
      rating: 4.5,
      orders: 97,
      duration: 75,
    ),
  ],
  'Carpet Cleaning': const [
    CleaningService(
      id: 'cp-1',
      name: 'Deluxe Carpet Shampoo',
      imageUrl: 'assets/services_images/home_cleaning.png',
      price: 699.0,
      rating: 4.4,
      orders: 45,
      duration: 80,
    ),
    CleaningService(
      id: 'cp-2',
      name: 'Upholstery & Carpet Combo',
      imageUrl: 'assets/services_images/home_cleaning.png',
      price: 1199.0,
      rating: 4.6,
      orders: 29,
      duration: 140,
    ),
  ],
};

// Providers
final selectedCategoryProvider = StateProvider<int>((ref) => 0);

final cartItemsProvider = Provider((ref) {
  return ref.watch(cartControllerProvider).items;
});

final servicesForSelectedCategoryProvider = Provider<List<CleaningService>>((
  ref,
) {
  final index = ref.watch(selectedCategoryProvider);
  if (index < 0 || index >= cleaningCategories.length) {
    return const [];
  }
  final category = cleaningCategories[index];
  return cleaningServicesByCategory[category] ?? const [];
});
