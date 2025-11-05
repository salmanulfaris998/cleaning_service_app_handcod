import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../auth/controllers/auth_controller.dart';
import 'widgets/account_option_tile.dart';
import 'widgets/account_profile_card.dart';
import 'widgets/account_profile_header_delegate.dart';
import 'widgets/account_wallet_card.dart';
import 'widgets/logout_dialog.dart';

class MyAccountScreen extends ConsumerWidget {
  const MyAccountScreen({super.key});

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LogoutDialog();
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final userName = user?.displayName ?? 
                    (user?.email?.split('@')[0]) ?? 
                    'User';
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_getGreeting()},',
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userName,
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverPersistentHeader(
                pinned: true,
                delegate: AccountProfileHeaderDelegate(
                  height: 120,
                  child: const AccountProfileCard(),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                0,
              ),
              sliver: const SliverToBoxAdapter(
                child: AccountWalletCard(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    AccountOptionTile(
                      iconAsset: AppImages.accountEditProfile,
                      label: 'Edit Profile',
                    ),
                    AccountOptionTile(
                      iconAsset: AppImages.accountSavedAddress,
                      label: 'Saved Address',
                    ),
                    AccountOptionTile(
                      iconAsset: AppImages.accountTermsConditions,
                      label: 'Terms & Conditions',
                    ),
                    AccountOptionTile(
                      iconAsset: AppImages.accountPrivacy,
                      label: 'Privacy Policy',
                    ),
                    AccountOptionTile(
                      iconAsset: AppImages.accountReferFriend,
                      label: 'Refer a friend',
                    ),
                    AccountOptionTile(
                      iconAsset: AppImages.accountCustomerSupport,
                      label: 'Customer Support',
                    ),
                    AccountOptionTile(
                      iconAsset: AppImages.accountLogout,
                      label: 'Log Out',
                      onTap: () => _showLogoutDialog(context, ref),
                    ),
                    SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
