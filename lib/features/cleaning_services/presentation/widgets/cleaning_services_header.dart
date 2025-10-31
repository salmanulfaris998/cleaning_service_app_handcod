import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancod_machine_test/features/cleaning_services/data/providers/service_providers.dart';

class CleaningServicesHeader extends ConsumerWidget {
  const CleaningServicesHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedCategoryIndexProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Container(
      width: double.infinity,
      color: const Color(0xFFDFFEEA),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No categories available'),
              ),
            );
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(categories.length, (index) {
                final isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () =>
                      ref.read(selectedCategoryIndexProvider.notifier).state = index,
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: isSelected
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF5FCD70), Color(0xFF0E826B)],
                            )
                          : null,
                      color: isSelected ? null : Colors.transparent,
                    ),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        },
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}
