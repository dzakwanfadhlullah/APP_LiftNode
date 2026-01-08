import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/app_theme.dart';
import '../core/shared_widgets.dart';
import '../core/settings_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  String _weightUnit = 'kg';
  int _weeklyGoal = 4;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: AppAnimations.normal,
        curve: AppAnimations.defaultCurve,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    final settings = context.read<SettingsProvider>();
    if (_nameController.text.isNotEmpty) {
      settings.setUserName(_nameController.text.trim());
    }
    settings.setWeightUnit(_weightUnit);
    settings.setWeeklyGoal(_weeklyGoal);
    settings.completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            _buildProgressBar(),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() => _currentPage = page);
                },
                children: [
                  _buildWelcomeStep(),
                  _buildGoalsStep(),
                  _buildDetailsStep(),
                ],
              ),
            ),

            // Bottom Navigation
            Padding(
              padding: Spacing.paddingScreen,
              child: Column(
                children: [
                  PremiumButton.hero(
                    title: _currentPage == _totalPages - 1
                        ? "GET STARTED"
                        : "CONTINUE",
                    onPress: _nextPage,
                    icon: _currentPage == _totalPages - 1
                        ? LucideIcons.rocket
                        : LucideIcons.arrowRight,
                  ),
                  if (_currentPage > 0) ...[
                    Spacing.vMd,
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: AppAnimations.normal,
                          curve: AppAnimations.defaultCurve,
                        );
                      },
                      child: Text(
                        'BACK',
                        style: AppTypography.labelMedium
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                  Spacing.vLg,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: Spacing.paddingScreen,
      child: Row(
        children: List.generate(_totalPages, (index) {
          final isActive = index <= _currentPage;
          return Expanded(
            child: AnimatedContainer(
              duration: AppAnimations.normal,
              height: 4,
              margin: EdgeInsets.only(right: index == _totalPages - 1 ? 0 : 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.brandPrimary : AppColors.border,
                borderRadius: AppRadius.roundedFull,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWelcomeStep() {
    return SingleChildScrollView(
      padding: Spacing.paddingScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.brandPrimary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.dumbbell,
                size: 48, color: AppColors.brandPrimary),
          ),
          Spacing.vXl,
          const Text('Welcome to\nGym Tracker Pro',
              style: AppTypography.displayMedium),
          Spacing.vMd,
          Text(
            'Your ultimate companion for strength and progress. Let\'s get you set up.',
            style: AppTypography.bodyLarge
                .copyWith(color: AppColors.textSecondary),
          ),
          Spacing.vXxl,
          GymInput(
            controller: _nameController,
            label: 'WHAT IS YOUR NAME?',
            hint: 'Athlete',
            prefixIcon: LucideIcons.user,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsStep() {
    return SingleChildScrollView(
      padding: Spacing.paddingScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text('Your Weekly Goal', style: AppTypography.displayMedium),
          Spacing.vMd,
          Text(
            'How many days a week do you plan to train?',
            style: AppTypography.bodyLarge
                .copyWith(color: AppColors.textSecondary),
          ),
          Spacing.vXxl,
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(7, (index) {
              final val = index + 1;
              final isSelected = _weeklyGoal == val;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _weeklyGoal = val);
                },
                child: AnimatedContainer(
                  duration: AppAnimations.fast,
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.brandPrimary : AppColors.bgCard,
                    borderRadius: AppRadius.roundedMd,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.brandPrimary
                          : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      val.toString(),
                      style: AppTypography.displaySmall.copyWith(
                        color:
                            isSelected ? Colors.black : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          Spacing.vXl,
          Text(
            'Recommended for beginners: 3-4 days',
            style:
                AppTypography.bodySmall.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: Spacing.paddingScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text('Almost Ready', style: AppTypography.displayMedium),
          Spacing.vMd,
          Text(
            'Pick your preferred measurement units.',
            style: AppTypography.bodyLarge
                .copyWith(color: AppColors.textSecondary),
          ),
          Spacing.vXxl,
          _buildUnitSelector(),
          Spacing.vXxl,
          const Row(
            children: [
              Icon(LucideIcons.shieldCheck, color: AppColors.success, size: 20),
              Spacing.hMd,
              Expanded(
                child: Text(
                  'Your data is stored locally on this device.',
                  style: AppTypography.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnitSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.roundedLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildUnitOption('kg', 'Kilograms'),
          _buildUnitOption('lbs', 'Pounds'),
        ],
      ),
    );
  }

  Widget _buildUnitOption(String val, String label) {
    final isSelected = _weightUnit == val;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _weightUnit = val);
        },
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.brandPrimary : Colors.transparent,
            borderRadius: val == 'kg'
                ? const BorderRadius.horizontal(left: Radius.circular(15))
                : const BorderRadius.horizontal(right: Radius.circular(15)),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                color: isSelected ? Colors.black : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
