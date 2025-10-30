import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_texts.dart';
import 'presentation/widgets/account_option_tile.dart';
import 'presentation/widgets/account_profile_card.dart';
import 'presentation/widgets/account_profile_header_delegate.dart';
import 'presentation/widgets/account_wallet_card.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                child: Text(
                  AppTexts.accountTitle,
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
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
                  const [
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
