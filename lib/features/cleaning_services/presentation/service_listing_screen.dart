import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hancod_machine_test/core/constants/app_colors.dart';
import 'package:hancod_machine_test/core/constants/app_spacing.dart';
import 'package:hancod_machine_test/features/cart/controller/cart_controller.dart';
import 'package:hancod_machine_test/features/common/cart_summary_bar.dart';
import 'package:hancod_machine_test/features/cleaning_services/controller/service_controller.dart';
import 'package:hancod_machine_test/features/cleaning_services/models/service_model.dart';
import 'package:hancod_machine_test/routes/app_routes.dart';
import 'package:hancod_machine_test/features/cleaning_services/presentation/widgets/cleaning_services_header.dart';
import 'package:hancod_machine_test/features/cleaning_services/presentation/widgets/service_item_card.dart';

class ServiceListingScreen extends ConsumerWidget {
  const ServiceListingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);
    final selectedServices = ref.watch(servicesForSelectedCategoryProvider);
    final totalPrice = cartState.subtotal;
    final totalItems = cartState.totalItems;

    void handleBack() {
      final router = GoRouter.of(context);
      if (router.canPop()) {
        router.pop();
      } else {
        context.go(AppRoutes.home);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: handleBack,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, size: 18),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Cleaning Services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const CleaningServicesHeader(),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.xxxl + AppSpacing.xxl,
                    ),
                    itemCount: selectedServices.length,
                    itemBuilder: (context, index) {
                      final cleaningService = selectedServices[index];
                      return ServiceCard(
                        service: ServiceModel(
                          id: cleaningService.id,
                          image: cleaningService.imageUrl,
                          title: cleaningService.name,
                          duration: '${cleaningService.duration} mins',
                          price: cleaningService.price,
                          rating: cleaningService.rating,
                          orders: cleaningService.orders,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            if (totalItems > 0)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: CartSummaryBar(
                    totalLabel:
                        '${totalItems} item${totalItems == 1 ? '' : 's'}',
                    totalAmount: totalPrice,
                    buttonLabel: 'VIEW CART',
                    buttonColor: AppColors.cta,
                    onPressed: () => context.go(AppRoutes.cart),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
