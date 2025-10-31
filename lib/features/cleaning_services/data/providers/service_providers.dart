import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/service_model.dart';
import '../repositories/service_repository.dart';

/// Provider for ServiceRepository
final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository();
});

/// Provider to fetch all services
final allServicesProvider = FutureProvider<List<ServiceModel>>((ref) async {
  final repository = ref.read(serviceRepositoryProvider);
  return await repository.fetchAllServices();
});

/// Provider to fetch services by category
final servicesByCategoryProvider = FutureProvider.family<List<ServiceModel>, String>(
  (ref, category) async {
    final repository = ref.read(serviceRepositoryProvider);
    return await repository.fetchServicesByCategory(category);
  },
);

/// Provider for available categories (from Supabase data)
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final services = await ref.watch(allServicesProvider.future);
  final categories = services.map((s) => s.category).toSet().toList();
  categories.sort();
  return categories;
});

/// State provider for selected category index
final selectedCategoryIndexProvider = StateProvider<int>((ref) => 0);

/// Provider for currently selected category name
final selectedCategoryProvider = Provider<String>((ref) {
  final index = ref.watch(selectedCategoryIndexProvider);
  final categoriesAsync = ref.watch(categoriesProvider);
  
  return categoriesAsync.when(
    data: (categories) {
      if (index >= 0 && index < categories.length) {
        return categories[index];
      }
      return categories.isNotEmpty ? categories[0] : '';
    },
    loading: () => '',
    error: (_, __) => '',
  );
});

/// Provider for services in the selected category
final servicesForSelectedCategoryProvider = FutureProvider<List<ServiceModel>>((ref) async {
  final category = ref.watch(selectedCategoryProvider);
  if (category.isEmpty) return [];
  
  final repository = ref.read(serviceRepositoryProvider);
  return await repository.fetchServicesByCategory(category);
});
