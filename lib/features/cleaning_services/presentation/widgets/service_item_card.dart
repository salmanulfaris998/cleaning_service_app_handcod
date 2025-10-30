import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancod_machine_test/core/constants/app_colors.dart';
import 'package:hancod_machine_test/core/constants/app_text_styles.dart';
import 'package:hancod_machine_test/features/cart/controller/cart_controller.dart';
import 'package:hancod_machine_test/features/cart/data/models/cart_model.dart';
import 'package:hancod_machine_test/features/cleaning_services/models/service_model.dart';

class ServiceCard extends ConsumerWidget {
  const ServiceCard({super.key, required this.service});

  final ServiceModel service;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);
    final cartNotifier = ref.read(cartControllerProvider.notifier);
    final quantity = cartState.itemById(service.id)?.quantity ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              service.image,
              height: 85,
              width: 85,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),

          //  Text + Button column
          Expanded(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                // ---- Text Section ----
                Padding(
                  padding: const EdgeInsets.only(right: 90), // space for button
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFC107),
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${service.rating.toStringAsFixed(1)}/5) ${service.orders} Orders',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.title,
                        style: AppTextStyles.heading2.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.duration,
                        style: AppTextStyles.bodyLight.copyWith(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹ ${service.price.toStringAsFixed(2)}',
                        style: AppTextStyles.price.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),

                // ---- Add Button (Bottom Right) ----
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        axis: Axis.horizontal,
                        child: child,
                      ),
                    ),
                    child: quantity == 0
                        ? InkWell(
                            key: const ValueKey('add_button'),
                            onTap: () {
                              cartNotifier.addItem(
                                CartItem(
                                  id: service.id,
                                  name: service.title,
                                  price: service.price,
                                  quantity: 1,
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF6CCB73),
                                    Color(0xFF3A9960),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(18),
                                  bottomRight: Radius.circular(18),
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Add',
                                    style: AppTextStyles.button.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.add,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            key: const ValueKey('quantity_controls'),
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: const BoxDecoration(
                              color: AppColors.neutral,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () =>
                                      cartNotifier.decrementItem(service.id),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      '-',
                                      style: AppTextStyles.button.copyWith(
                                        color: AppColors.quantityGreen,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '$quantity',
                                  style: AppTextStyles.button.copyWith(
                                    color: AppColors.quantityGreen,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () =>
                                      cartNotifier.incrementItem(service.id),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      '+',
                                      style: AppTextStyles.button.copyWith(
                                        color: AppColors.quantityGreen,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
