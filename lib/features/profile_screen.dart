import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/app_theme.dart';
import '../core/shared_widgets.dart';

// =============================================================================
// PHASE 6: PROFILE SCREEN ENHANCEMENTS
// =============================================================================

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  // 6.3 Settings state
  bool _notificationsEnabled = true;
  bool _hapticFeedbackEnabled = true;
  bool _autoRestTimer = true;
  int _defaultRestSeconds = 90;
  String _weightUnit = 'kg';

  // 6.4 Theme state
  String _selectedTheme = 'dark';
  Color _accentColor = AppColors.brandPrimary;

  // Animation controller
  late AnimationController _animController;
  late Animation<double> _levelAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );
    _levelAnimation = Tween<double>(begin: 0, end: 0.75).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(context),
          SliverPadding(
            padding: Spacing.paddingScreen,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Spacing.vMd,
                // 6.2 Stats Overview
                _buildSectionTitle('YOUR PERFORMANCE'),
                Spacing.vMd,
                _buildStatsGrid(),
                Spacing.vXl,
                // Achievements
                _buildSectionTitle('ACHIEVEMENTS'),
                Spacing.vMd,
                _buildAchievements(),
                Spacing.vXl,
                // 6.3 Settings & Preferences
                _buildSectionTitle('PREFERENCES'),
                Spacing.vMd,
                _buildPreferencesSection(),
                Spacing.vXl,
                // 6.4 Appearance
                _buildSectionTitle('APPEARANCE'),
                Spacing.vMd,
                _buildAppearanceSection(),
                Spacing.vXl,
                // Account
                _buildSectionTitle('ACCOUNT'),
                Spacing.vMd,
                _buildAccountSection(),
                Spacing.vXxl,
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 6.1 ENHANCED USER PROFILE CARD
  // ===========================================================================

  Widget _buildSliverHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      backgroundColor: AppColors.bgMain,
      pinned: true,
      actions: [
        IconButton(
          onPressed: () => _showEditProfileSheet(context),
          icon: const Icon(LucideIcons.pencil, size: 20),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient glow effect
            Positioned(
              top: -80,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _accentColor.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Profile content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // Avatar with level progress
                GestureDetector(
                  onTap: () => _showEditProfileSheet(context),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Level progress ring
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: AnimatedBuilder(
                          animation: _levelAnimation,
                          builder: (context, child) {
                            return CircularProgressIndicator(
                              value: _levelAnimation.value,
                              strokeWidth: 4,
                              color: _accentColor,
                              backgroundColor: AppColors.bgCard,
                            );
                          },
                        ),
                      ),
                      // Avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.bgCard,
                          border: Border.all(
                              color: _accentColor.withValues(alpha: 0.3),
                              width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: _accentColor.withValues(alpha: 0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                          image: const DecorationImage(
                            image: NetworkImage(
                                'https://i.pravatar.cc/300?u=dzakwan'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Level badge
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _accentColor,
                                _accentColor.withValues(alpha: 0.8)
                              ],
                            ),
                            borderRadius: AppRadius.roundedFull,
                            boxShadow: [
                              BoxShadow(
                                color: _accentColor.withValues(alpha: 0.5),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Text(
                            'LVL 24',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Edit overlay on hover
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.bgCardHover,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.camera,
                              size: 14, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacing.vMd,
                // Name
                const Text('Dzakwan', style: AppTypography.displayMedium),
                Spacing.vXxs,
                // Streak info
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.flame,
                        size: 16, color: Color(0xFFF97316)),
                    Spacing.hXs,
                    Text(
                      '12 Day Streak',
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                Spacing.vMd,
                // Membership badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: const BoxDecoration(
                    gradient: AppColors.gradientPrimary,
                    borderRadius: AppRadius.roundedFull,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.crown, size: 14, color: _accentColor),
                      Spacing.hXs,
                      Text(
                        'ELITE MEMBER',
                        style: AppTypography.labelSmall
                            .copyWith(color: _accentColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context) {
    if (!kIsWeb) HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const _EditProfileSheet(),
    );
  }

  // ===========================================================================
  // 6.2 STATS OVERVIEW
  // ===========================================================================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.overline.copyWith(
        letterSpacing: 1.5,
        color: AppColors.textMuted,
      ),
    );
  }

  Widget _buildStatsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _StatCard(
              label: 'Total Workouts',
              value: '48',
              icon: LucideIcons.dumbbell,
              width: itemWidth,
              color: AppColors.brandSecondary,
              trend: '+12%',
              trendUp: true,
            ),
            _StatCard(
              label: 'PRs Set',
              value: '12',
              icon: LucideIcons.trophy,
              width: itemWidth,
              color: AppColors.brandPrimary,
              trend: '+3',
              trendUp: true,
            ),
            _StatCard(
              label: 'Active Hours',
              value: '156h',
              icon: LucideIcons.clock,
              width: itemWidth,
              color: const Color(0xFF3B82F6),
            ),
            _StatCard(
              label: 'Completion Rate',
              value: '92%',
              icon: LucideIcons.target,
              width: itemWidth,
              color: const Color(0xFFA855F7),
              showProgress: true,
              progressValue: 0.92,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAchievements() {
    final achievements = [
      {
        'icon': LucideIcons.flame,
        'label': '7 Day Streak',
        'color': const Color(0xFFF97316),
        'unlocked': true
      },
      {
        'icon': LucideIcons.dumbbell,
        'label': 'Weightlifter',
        'color': const Color(0xFF3B82F6),
        'unlocked': true
      },
      {
        'icon': LucideIcons.zap,
        'label': 'High Intensity',
        'color': const Color(0xFFEAB308),
        'unlocked': true
      },
      {
        'icon': LucideIcons.medal,
        'label': 'Early Bird',
        'color': AppColors.brandPrimary,
        'unlocked': true
      },
      {
        'icon': LucideIcons.star,
        'label': '100 Workouts',
        'color': AppColors.textMuted,
        'unlocked': false
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: achievements.map((a) {
          final unlocked = a['unlocked'] as bool;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GymCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Opacity(
                opacity: unlocked ? 1.0 : 0.4,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      a['icon'] as IconData,
                      size: 16,
                      color: a['color'] as Color,
                    ),
                    Spacing.hSm,
                    Text(
                      a['label'] as String,
                      style: AppTypography.labelSmall,
                    ),
                    if (!unlocked) ...[
                      Spacing.hSm,
                      const Icon(LucideIcons.lock,
                          size: 12, color: AppColors.textMuted),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ===========================================================================
  // 6.3 SETTINGS & PREFERENCES
  // ===========================================================================

  Widget _buildPreferencesSection() {
    return GymCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildToggleTile(
            icon: LucideIcons.bell,
            title: 'Notifications',
            subtitle: 'Workout reminders & updates',
            value: _notificationsEnabled,
            onChanged: (v) => setState(() => _notificationsEnabled = v),
          ),
          const GymDivider(height: 1),
          _buildToggleTile(
            icon: LucideIcons.vibrate,
            title: 'Haptic Feedback',
            subtitle: 'Vibration on button press',
            value: _hapticFeedbackEnabled,
            onChanged: (v) => setState(() => _hapticFeedbackEnabled = v),
          ),
          const GymDivider(height: 1),
          _buildToggleTile(
            icon: LucideIcons.timer,
            title: 'Auto Rest Timer',
            subtitle: 'Start timer after set completion',
            value: _autoRestTimer,
            onChanged: (v) => setState(() => _autoRestTimer = v),
          ),
          const GymDivider(height: 1),
          _buildOptionTile(
            icon: LucideIcons.clock,
            title: 'Default Rest Time',
            value: '${_defaultRestSeconds}s',
            onTap: () => _showRestTimeSelector(context),
          ),
          const GymDivider(height: 1),
          _buildOptionTile(
            icon: LucideIcons.scale,
            title: 'Weight Unit',
            value: _weightUnit.toUpperCase(),
            onTap: () => _showWeightUnitSelector(context),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: Spacing.paddingCard,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppColors.bgCardHover,
              borderRadius: AppRadius.roundedMd,
            ),
            child: Icon(icon, size: 20, color: AppColors.textSecondary),
          ),
          Spacing.hMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium),
                Text(subtitle, style: AppTypography.caption),
              ],
            ),
          ),
          GymSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: Spacing.paddingCard,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.bgCardHover,
                borderRadius: AppRadius.roundedMd,
              ),
              child: Icon(icon, size: 20, color: AppColors.textSecondary),
            ),
            Spacing.hMd,
            Expanded(
              child: Text(title, style: AppTypography.titleMedium),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: const BoxDecoration(
                color: AppColors.bgCardHover,
                borderRadius: AppRadius.roundedSm,
              ),
              child: Text(value, style: AppTypography.labelMedium),
            ),
            Spacing.hSm,
            const Icon(LucideIcons.chevronRight,
                size: 16, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  void _showRestTimeSelector(BuildContext context) {
    final options = [30, 60, 90, 120, 180];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: Spacing.paddingCard,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.border,
                borderRadius: AppRadius.roundedFull,
              ),
            ),
            Spacing.vLg,
            const Text('Default Rest Time', style: AppTypography.headlineSmall),
            Spacing.vLg,
            Wrap(
              spacing: 10,
              children: options.map((seconds) {
                final isSelected = seconds == _defaultRestSeconds;
                return GestureDetector(
                  onTap: () {
                    setState(() => _defaultRestSeconds = seconds);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.brandPrimary
                          : AppColors.bgCardHover,
                      borderRadius: AppRadius.roundedMd,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.brandPrimary
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      '${seconds}s',
                      style: AppTypography.titleMedium.copyWith(
                        color: isSelected
                            ? AppColors.onPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            Spacing.vXl,
          ],
        ),
      ),
    );
  }

  void _showWeightUnitSelector(BuildContext context) {
    final units = ['kg', 'lbs'];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: Spacing.paddingCard,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.border,
                borderRadius: AppRadius.roundedFull,
              ),
            ),
            Spacing.vLg,
            const Text('Weight Unit', style: AppTypography.headlineSmall),
            Spacing.vLg,
            Row(
              children: units.map((unit) {
                final isSelected = unit == _weightUnit;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _weightUnit = unit);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.brandPrimary
                            : AppColors.bgCardHover,
                        borderRadius: AppRadius.roundedMd,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.brandPrimary
                              : AppColors.border,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          unit.toUpperCase(),
                          style: AppTypography.headlineSmall.copyWith(
                            color: isSelected
                                ? AppColors.onPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            Spacing.vXl,
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 6.4 APPEARANCE / THEME
  // ===========================================================================

  Widget _buildAppearanceSection() {
    final accentColors = [
      AppColors.brandPrimary,
      const Color(0xFF3B82F6), // Blue
      const Color(0xFFA855F7), // Purple
      const Color(0xFFF97316), // Orange
      const Color(0xFFEF4444), // Red
      const Color(0xFF14B8A6), // Teal
    ];

    return GymCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Theme mode
          Padding(
            padding: Spacing.paddingCard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.bgCardHover,
                        borderRadius: AppRadius.roundedMd,
                      ),
                      child: const Icon(LucideIcons.palette,
                          size: 20, color: AppColors.textSecondary),
                    ),
                    Spacing.hMd,
                    const Text('Theme', style: AppTypography.titleMedium),
                  ],
                ),
                Spacing.vMd,
                Row(
                  children: [
                    _buildThemeOption('dark', LucideIcons.moon, 'Dark'),
                    Spacing.hMd,
                    _buildThemeOption('light', LucideIcons.sun, 'Light'),
                    Spacing.hMd,
                    _buildThemeOption('auto', LucideIcons.monitor, 'System'),
                  ],
                ),
              ],
            ),
          ),
          const GymDivider(height: 1),
          // Accent color
          Padding(
            padding: Spacing.paddingCard,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.bgCardHover,
                        borderRadius: AppRadius.roundedMd,
                      ),
                      child: const Icon(LucideIcons.paintbrush,
                          size: 20, color: AppColors.textSecondary),
                    ),
                    Spacing.hMd,
                    const Text('Accent Color',
                        style: AppTypography.titleMedium),
                  ],
                ),
                Spacing.vMd,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: accentColors.map((color) {
                    final isSelected = color == _accentColor;
                    return GestureDetector(
                      onTap: () {
                        if (!kIsWeb) HapticFeedback.selectionClick();
                        setState(() => _accentColor = color);
                      },
                      child: AnimatedContainer(
                        duration: AppAnimations.fast,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isSelected ? Colors.white : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.5),
                                    blurRadius: 12,
                                  ),
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(LucideIcons.check,
                                size: 18, color: Colors.black)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(String theme, IconData icon, String label) {
    final isSelected = _selectedTheme == theme;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!kIsWeb) HapticFeedback.selectionClick();
          setState(() => _selectedTheme = theme);
        },
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.brandPrimary.withValues(alpha: 0.1)
                : AppColors.bgCardHover,
            borderRadius: AppRadius.roundedMd,
            border: Border.all(
              color: isSelected ? AppColors.brandPrimary : AppColors.border,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 22,
                  color: isSelected
                      ? AppColors.brandPrimary
                      : AppColors.textSecondary),
              Spacing.vXs,
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: isSelected
                      ? AppColors.brandPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // ACCOUNT SECTION
  // ===========================================================================

  Widget _buildAccountSection() {
    return GymCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildAccountTile(
            icon: LucideIcons.user,
            title: 'Account Settings',
            subtitle: 'Profile, email, password',
          ),
          const GymDivider(height: 1),
          _buildAccountTile(
            icon: LucideIcons.cloud,
            title: 'Cloud Sync',
            subtitle: 'Backup your data',
            trailing:
                const GymBadge(text: 'SOON', color: AppColors.brandSecondary),
          ),
          const GymDivider(height: 1),
          _buildAccountTile(
            icon: LucideIcons.circleHelp,
            title: 'Help & Support',
            subtitle: 'FAQ, contact us',
          ),
          const GymDivider(height: 1),
          _buildAccountTile(
            icon: LucideIcons.fileText,
            title: 'Privacy Policy',
            subtitle: 'Terms and conditions',
          ),
          const GymDivider(height: 1),
          _buildAccountTile(
            icon: LucideIcons.logOut,
            title: 'Sign Out',
            color: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? color,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title coming soon!')),
        );
      },
      child: Padding(
        padding: Spacing.paddingCard,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    (color ?? AppColors.textSecondary).withValues(alpha: 0.1),
                borderRadius: AppRadius.roundedMd,
              ),
              child:
                  Icon(icon, size: 20, color: color ?? AppColors.textSecondary),
            ),
            Spacing.hMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(color: color),
                  ),
                  if (subtitle != null)
                    Text(subtitle, style: AppTypography.caption),
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (trailing == null)
              const Icon(LucideIcons.chevronRight,
                  size: 16, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// STAT CARD WITH TRENDS
// =============================================================================

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final double width;
  final Color color;
  final String? trend;
  final bool trendUp;
  final bool showProgress;
  final double progressValue;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.width,
    required this.color,
    this.trend,
    this.trendUp = true,
    this.showProgress = false,
    this.progressValue = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GymCard(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: AppRadius.roundedMd,
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              if (trend != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (trendUp ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.1),
                    borderRadius: AppRadius.roundedXs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendUp
                            ? LucideIcons.trendingUp
                            : LucideIcons.trendingDown,
                        size: 12,
                        color: trendUp ? AppColors.success : AppColors.error,
                      ),
                      Spacing.hXxs,
                      Text(
                        trend!,
                        style: AppTypography.caption.copyWith(
                          color: trendUp ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Spacing.vMd,
          Text(value, style: AppTypography.stat),
          Spacing.vXxs,
          Text(label, style: AppTypography.caption),
          if (showProgress) ...[
            Spacing.vMd,
            GymProgressBar(
                value: progressValue,
                progressGradient: AppColors.gradientPrimary),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// EDIT PROFILE SHEET
// =============================================================================

class _EditProfileSheet extends StatelessWidget {
  const _EditProfileSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: Spacing.paddingCard,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: const BoxDecoration(
              color: AppColors.border,
              borderRadius: AppRadius.roundedFull,
            ),
          ),
          Spacing.vLg,
          const Text('Edit Profile', style: AppTypography.headlineSmall),
          Spacing.vXl,
          // Avatar
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/300?u=dzakwan'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.brandPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.camera,
                      size: 16, color: Colors.black),
                ),
              ),
            ],
          ),
          Spacing.vXl,
          // Name input
          const GymInput(
            label: 'Display Name',
            hint: 'Enter your name',
            prefixIcon: LucideIcons.user,
          ),
          Spacing.vMd,
          // Email
          const GymInput(
            label: 'Email',
            hint: 'your@email.com',
            prefixIcon: LucideIcons.mail,
          ),
          Spacing.vMd,
          // Bio
          const GymInput(
            label: 'Bio',
            hint: 'Tell us about yourself',
            prefixIcon: LucideIcons.fileText,
          ),
          const Spacer(),
          NeonButton(
            title: 'Save Changes',
            icon: LucideIcons.check,
            onPress: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated!')),
              );
            },
          ),
          Spacing.vMd,
        ],
      ),
    );
  }
}
