import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/app_theme.dart';
import '../core/shared_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(context),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),
                const _ProfileSectionTitle(title: 'YOUR PERFORMANCE'),
                const SizedBox(height: 16),
                const _ProfileStatsBento(),
                const SizedBox(height: 32),
                const _ProfileSectionTitle(title: 'ACHIEVEMENTS'),
                const SizedBox(height: 16),
                const _ProfileAchievementsRow(),
                const SizedBox(height: 32),
                const _ProfileSectionTitle(title: 'ACCOUNT'),
                const SizedBox(height: 16),
                const _ProfileActionList(),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      backgroundColor: AppColors.bgMain,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient glow
            Positioned(
              top: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.brandSecondary.withValues(alpha: 0.1),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const SizedBox(
                      width: 110,
                      height: 110,
                      child: CircularProgressIndicator(
                        value: 0.75,
                        strokeWidth: 4,
                        color: AppColors.brandSecondary,
                        backgroundColor: AppColors.bgCard,
                      ),
                    ),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.bgCard,
                        border: Border.all(color: AppColors.border, width: 2),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://i.pravatar.cc/300?u=dzakwan'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.brandSecondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'LVL 24',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const GymTypography(
                  'Dzakwan',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.flame, size: 14, color: Colors.orange),
                    SizedBox(width: 4),
                    GymTypography(
                      '12 Day Streak',
                      color: AppColors.textSecondary,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const GymBadge(
                  text: 'ELITE MEMBER',
                  color: AppColors.brandSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSectionTitle extends StatelessWidget {
  final String title;
  const _ProfileSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return GymTypography(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: AppColors.textMuted,
      ),
    );
  }
}

class _ProfileStatsBento extends StatelessWidget {
  const _ProfileStatsBento();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ProfileStatCard(
                label: 'Total Workouts',
                value: '48',
                icon: LucideIcons.dumbbell,
                width: itemWidth,
                accent: AppColors.brandSecondary),
            _ProfileStatCard(
                label: 'PRs Broke',
                value: '12',
                icon: LucideIcons.trophy,
                width: itemWidth,
                accent: AppColors.brandPrimary),
            _ProfileStatCard(
                label: 'Active Hours',
                value: '156h',
                icon: LucideIcons.clock,
                width: itemWidth,
                accent: Colors.blue),
            _ProfileStatCard(
                label: 'Completion',
                value: '92%',
                icon: LucideIcons.circleCheck,
                width: itemWidth,
                accent: Colors.purpleAccent),
          ],
        );
      },
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final double width;
  final Color accent;

  const _ProfileStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.width,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(height: 16),
          GymTypography(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          GymTypography(
            label,
            color: AppColors.textSecondary,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ProfileAchievementsRow extends StatelessWidget {
  const _ProfileAchievementsRow();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _ProfileAchievementItem(
              icon: LucideIcons.flame,
              label: '7 Day Streak',
              color: Colors.orange),
          _ProfileAchievementItem(
              icon: LucideIcons.dumbbell,
              label: 'Weightlifter',
              color: Colors.blue),
          _ProfileAchievementItem(
              icon: LucideIcons.zap,
              label: 'High Intensity',
              color: Colors.yellow),
          _ProfileAchievementItem(
              icon: LucideIcons.medal,
              label: 'Early Bird',
              color: AppColors.brandPrimary),
        ],
      ),
    );
  }
}

class _ProfileAchievementItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ProfileAchievementItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.bgCardHover,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _ProfileActionList extends StatelessWidget {
  const _ProfileActionList();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _ProfileActionItem(
            icon: LucideIcons.settings,
            title: 'Account Settings',
            subtitle: 'Manage your profile and security'),
        _ProfileActionItem(
            icon: LucideIcons.creditCard,
            title: 'Subscription & Billing',
            subtitle: 'Manage your Pro plan'),
        _ProfileActionItem(
            icon: LucideIcons.bell,
            title: 'Notifications',
            subtitle: 'Customize your alerts'),
        _ProfileActionItem(
            icon: LucideIcons.circleHelp,
            title: 'Help & Support',
            subtitle: 'Get in touch with us'),
        SizedBox(height: 32),
        _ProfileSectionTitle(title: 'CLOUD & BACKUP'),
        SizedBox(height: 16),
        _ProfileActionItem(
          icon: LucideIcons.cloud,
          title: 'Cloud Sync',
          subtitle: 'Sync data across devices',
          trailing: GymBadge(text: 'SOON', color: AppColors.brandSecondary),
        ),
        SizedBox(height: 16),
        _ProfileActionItem(
            icon: LucideIcons.logOut,
            title: 'Logout',
            subtitle: null,
            color: Colors.redAccent),
      ],
    );
  }
}

class _ProfileActionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? color;
  final Widget? trailing;

  const _ProfileActionItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.color,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title details coming soon!')),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (color ?? AppColors.textPrimary).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: color ?? AppColors.textPrimary),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: color ?? Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12),
              )
            : null,
        trailing: trailing ??
            Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: AppColors.textMuted.withValues(alpha: 0.5),
            ),
      ),
    );
  }
}
