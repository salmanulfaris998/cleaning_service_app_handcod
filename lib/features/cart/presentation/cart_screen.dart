import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_texts.dart';
import '../../../routes/app_routes.dart';
import '../../cleaning_services/data/providers/service_providers.dart';
import '../../cleaning_services/models/service_model.dart';
import '../../common/cart_summary_bar.dart';
import '../../orders/data/service/order_service.dart';
import '../controller/cart_controller.dart';
import '../data/models/cart_model.dart';
import '../data/models/coupon_model.dart';
import '../data/providers/coupon_providers.dart';
import '../presentation/widgets/bill_details_card.dart';
import '../presentation/widgets/cart_product_card.dart';
import '../presentation/widgets/coupon_code_field.dart';
import '../presentation/widgets/quantity_control.dart';

final _couponControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) {
    final controller = TextEditingController();
    ref.onDispose(controller.dispose);
    return controller;
  },
);

final _isPlacingOrderProvider = StateProvider.autoDispose<bool>((ref) => false);

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false, // Prevent swipe-to-exit, use back button instead
      onPopInvoked: (didPop) {
        if (!didPop) {
          // If user tries to swipe back, navigate to home
          context.go(AppRoutes.home);
        }
      },
      child: _buildCartContent(context, ref),
    );
  }

  Widget _buildCartContent(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartControllerProvider.notifier);
    final summary = ref.watch(cartSummaryProvider);
    final couponController = ref.watch(_couponControllerProvider);
    final appliedCoupon = ref.watch(appliedCouponProvider);
    final rawCouponDiscount = (appliedCoupon != null && appliedCoupon.isValid)
        ? appliedCoupon.calculateDiscount(summary.state.subtotal)
        : 0.0;
    final couponDiscount = rawCouponDiscount
        .clamp(0.0, summary.state.subtotal)
        .toDouble();
    final subtotal = summary.state.subtotal;
    final taxAmount = summary.serviceFee;
    final computedTotal = subtotal - couponDiscount + taxAmount;
    final billTotal = computedTotal < 0 ? 0.0 : computedTotal;
    final billItems = summary.buildBillItems(
      subtotalLabel: AppTexts.cartSubtotalLabel,
      serviceFeeLabel: AppTexts.cartServiceFeeLabel,
      couponLabel: AppTexts.cartCouponDiscountLabel,
      couponDiscount: couponDiscount,
    );
    final frequentlyAddedServicesAsync = ref.watch(allServicesProvider);
    final isPlacingOrder = ref.watch(_isPlacingOrderProvider);

    Future<void> handleApplyCoupon() async {
      FocusScope.of(context).unfocus();
      final code = couponController.text.trim();
      if (code.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a coupon code.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Validating coupon...'),
          duration: Duration(seconds: 1),
        ),
      );

      // Validate coupon
      final couponService = ref.read(couponServiceProvider);
      final coupon = await couponService.validateCoupon(code);

      if (coupon == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid or expired coupon: $code'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Apply coupon
      final discountPercent = coupon['discount_percent'];
      ref.read(appliedCouponProvider.notifier).state = 
          CouponModel.fromJson(coupon);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Coupon applied: $code ($discountPercent% off)'),
          backgroundColor: Colors.green,
        ),
      );
    }

    void handleBack() {
      // Always go back to home when back is pressed from cart
      context.go(AppRoutes.home);
    }

    void handleVisitServices() {
      context.push(AppRoutes.services);
    }

    Future<void> handlePlaceOrder() async {
      if (cartState.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your cart is empty.')),
        );
        return;
      }

      if (isPlacingOrder) return;

      final placingOrder = ref.read(_isPlacingOrderProvider.notifier);
      placingOrder.state = true;

      try {
        final success = await orderService.createOrder(
          subtotal: subtotal,
          couponDiscount: couponDiscount,
          tax: taxAmount,
          total: billTotal,
          couponCode: appliedCoupon?.code,
        );

        if (!context.mounted) return;

        if (success) {
          cartNotifier.clearCart();
          ref.read(appliedCouponProvider.notifier).state = null;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking successful!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to complete booking. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        placingOrder.state = false;
      }
    }

    Widget buildFrequentlyAddedSection() {
      return frequentlyAddedServicesAsync.when(
        data: (services) {
          if (services.isEmpty) {
            return const SizedBox.shrink();
          }

          final sortedServices = [...services]
            ..sort((a, b) => (b.ordersCount).compareTo(a.ordersCount));
          final topServices = sortedServices.take(5).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Text('Frequently added services', style: AppTextStyles.heading2),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 210,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemCount: topServices.length,
                  itemBuilder: (context, index) {
                    final ServiceModel service = topServices[index];
                    return CartProductCard(
                      imageUrl: service.imageUrl,
                      title: service.name,
                      price: service.price,
                      onAdd: () => cartNotifier.addItem(
                        CartItem(
                          id: service.id,
                          name: service.name,
                          price: service.price,
                          quantity: 1,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        error: (_, __) => const SizedBox.shrink(),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: InkWell(
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
        ),
        title: const Text(
          'Cart',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: cartState.isEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          'Your cart is empty',
                          style: AppTextStyles.heading2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Add services to see them listed here.',
                          style: AppTextStyles.bodyLight,
                          textAlign: TextAlign.center,
                        ),
                        buildFrequentlyAddedSection(),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _EmptyCartVisitServices(onTap: handleVisitServices),
                ],
              )
            : ListView(
                children: [
                  ...List.generate(cartState.items.length, (index) {
                    final item = cartState.items[index];
                    final itemTotal = item.price * item.quantity;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == cartState.items.length - 1
                            ? 0
                            : AppSpacing.lg,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              '${index + 1}.  ${item.name}',
                              style: AppTextStyles.body.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 40,
                                child: Center(
                                  child: QuantityControl(
                                    quantity: item.quantity,
                                    onDecrease: () =>
                                        cartNotifier.decrementItem(item.id),
                                    onIncrease: () =>
                                        cartNotifier.incrementItem(item.id),
                                  ),
                                ),
                              ),

                              const SizedBox(width: AppSpacing.md),

                              Center(
                                child: Text(
                                  '₹${itemTotal.toStringAsFixed(0)}',
                                  style: AppTextStyles.price.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 12),
                    child: GestureDetector(
                      onTap: () => context.push(AppRoutes.services),
                      child: Text(
                        AppTexts.cartAddMoreServices,
                        textAlign: TextAlign.left,
                        style: AppTextStyles.greenHighlight.copyWith(
                          decoration: TextDecoration.none,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  buildFrequentlyAddedSection(),
                  const SizedBox(height: AppSpacing.xl),
                  CouponCodeField(
                    controller: couponController,
                    onApply: handleApplyCoupon,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  BillDetailsCard(
                    products: cartState.items,
                    items: billItems,
                    total: billTotal,
                  ),
                ],
              ),
      ),
      bottomNavigationBar: cartState.isEmpty
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: CartSummaryBar(
                totalLabel: AppTexts.cartGrandTotalLabel,
                totalAmount: billTotal,
                buttonLabel:
                    isPlacingOrder ? 'Processing…' : AppTexts.cartBookSlotCta,
                buttonGradient: const LinearGradient(
                  colors: [Color(0xFF6CCB73), Color(0xFF188B5A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onPressed: () {
                  if (!isPlacingOrder) {
                    handlePlaceOrder();
                  }
                },
              ),
            ),
    );
  }
}

class _EmptyCartVisitServices extends StatelessWidget {
  const _EmptyCartVisitServices({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6CCB73), Color(0xFF3A9960)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 26,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Visit services and add to cart',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
