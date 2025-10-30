import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancod_machine_test/features/services/controller/service_controller.dart';

class CleaningServicesHeader extends ConsumerWidget {
  const CleaningServicesHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedCategoryProvider);

    return Container(
      width: double.infinity,
      color: const Color(0xFFDFFEEA),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(cleaningCategories.length, (index) {
            final isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () =>
                  ref.read(selectedCategoryProvider.notifier).state = index,
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
                          colors: [
                            Color(0xFF5FCD70),
                            Color(0xFF0E826B),
                          ],
                        )
                      : null,
                  color: isSelected ? null : Colors.transparent,
                ),
                child: Text(
                  cleaningCategories[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
