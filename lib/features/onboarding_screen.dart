import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/app_theme.dart';
import '../core/shared_widgets.dart';
import '../core/settings_provider.dart';
import '../core/widgets/animated_aurora_background.dart';
import '../core/widgets/premium_onboarding_widgets.dart';

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
    return AnimatedAuroraBackground(
      child: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            PremiumProgressIndicator(
              totalSteps: _totalPages,
              currentStep: _currentPage,
            ),

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

  Widget _buildWelcomeStep() {
    return SingleChildScrollView(
      padding: Spacing.paddingScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Opacity(
                  opacity: value,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.brandPrimary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brandPrimary.withValues(alpha: 0.2),
                          blurRadius: 30 * value,
                          spreadRadius: 10 * value,
                        ),
                      ],
                    ),
                    child: const Icon(LucideIcons.dumbbell,
                        size: 64, color: AppColors.brandPrimary),
                  ),
                ),
              );
            },
          ),
          Spacing.vXl,
          _buildStaggerText(
            'Welcome to\nGym Tracker Pro',
            AppTypography.displayMedium,
            delayMs: 300,
          ),
          Spacing.vMd,
          _buildStaggerText(
            'Your ultimate companion for strength and progress. Let\'s get you set up.',
            AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
            delayMs: 600,
          ),
          Spacing.vXxl,
          _buildStaggerText(
            '',
            const TextStyle(),
            delayMs: 900,
            child: GymInput(
              controller: _nameController,
              label: 'WHAT IS YOUR NAME?',
              hint: 'Athlete',
              prefixIcon: LucideIcons.user,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaggerText(String text, TextStyle style,
      {int delayMs = 0, Widget? child}) {
    return _StaggeredFadeItem(
      delay: Duration(milliseconds: delayMs),
      child: child ?? Text(text, style: style),
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
          Center(
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(7, (index) {
                final val = index + 1;
                final isSelected = _weeklyGoal == val;
                return SelectableNumberBadge(
                  number: val,
                  isSelected: isSelected,
                  onTap: () => setState(() => _weeklyGoal = val),
                );
              }),
            ),
          ),
          Spacing.vXxl,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgCard.withValues(alpha: 0.5),
              borderRadius: AppRadius.roundedMd,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.info,
                    size: 20, color: AppColors.brandPrimary),
                Spacing.hMd,
                Expanded(
                  child: Text(
                    'Recommended for beginners: 3-4 days',
                    style: AppTypography.bodySmall
                        .copyWith(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
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
          AnimatedSegmentedControl(
            selectedValue: _weightUnit,
            values: const ['kg', 'lbs'],
            labels: const ['Kilograms (kg)', 'Pounds (lbs)'],
            onChanged: (val) => setState(() => _weightUnit = val),
          ),
          Spacing.vXxl,
          GlassCard.frosted(
            child: Row(
              children: [
                const Icon(LucideIcons.shieldCheck,
                    color: AppColors.success, size: 20),
                Spacing.hMd,
                Expanded(
                  child: Text(
                    'Your data is stored locally on this device.',
                    style: AppTypography.bodySmall,
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

class _StaggeredFadeItem extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _StaggeredFadeItem({required this.child, required this.delay});

  @override
  State<_StaggeredFadeItem> createState() => _StaggeredFadeItemState();
}

class _StaggeredFadeItemState extends State<_StaggeredFadeItem> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(top: _visible ? 0 : 20),
        child: widget.child,
      ),
    );
  }
}
