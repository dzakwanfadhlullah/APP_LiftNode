import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import '../app_theme.dart';
import '../../models/models.dart';

// =============================================================================
// 1. GRADIENT AVATAR RING
// =============================================================================

class GradientAvatarRing extends StatefulWidget {
  final Widget child;
  final double size;
  final List<Color>? colors;

  const GradientAvatarRing({
    super.key,
    required this.child,
    this.size = 52,
    this.colors,
  });

  @override
  State<GradientAvatarRing> createState() => _GradientAvatarRingState();
}

class _GradientAvatarRingState extends State<GradientAvatarRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors ??
        [
          AppColors.brandPrimary,
          AppColors.brandSecondary,
          AppColors.brandPrimary.withValues(alpha: 0.5),
          AppColors.brandSecondary.withValues(alpha: 0.8),
          AppColors.brandPrimary,
        ];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: colors,
              transform: GradientRotation(_controller.value * 2 * math.pi),
            ),
          ),
          padding: const EdgeInsets.all(2), // The thickness of the ring
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.bgMain,
              shape: BoxShape.circle,
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

// =============================================================================
// 2. ANIMATED FIRE BADGE
// =============================================================================

class AnimatedFireBadge extends StatefulWidget {
  final int streak;
  final VoidCallback onTap;

  const AnimatedFireBadge({
    super.key,
    required this.streak,
    required this.onTap,
  });

  @override
  State<AnimatedFireBadge> createState() => _AnimatedFireBadgeState();
}

class _AnimatedFireBadgeState extends State<AnimatedFireBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 2.0, end: 8.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color fireColor = Color(0xFFF97316);

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: fireColor.withValues(alpha: 0.1),
              borderRadius: AppRadius.roundedFull,
              border: Border.all(
                color: fireColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: widget.streak > 0
                  ? [
                      BoxShadow(
                        color: fireColor.withValues(alpha: 0.2),
                        blurRadius: _glowAnimation.value,
                        spreadRadius: 1,
                      )
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (widget.streak > 0)
                      Icon(
                        LucideIcons.flame,
                        size: 18,
                        color: fireColor.withValues(alpha: 0.4),
                      ),
                    Icon(
                      LucideIcons.flame,
                      size: 18,
                      color: fireColor,
                    ),
                  ],
                ),
                Spacing.hXs,
                Text(
                  '${widget.streak} Day',
                  style: AppTypography.labelMedium.copyWith(
                    color: fireColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// =============================================================================
// 3. PREMIUM HERO CARD
// =============================================================================

class PremiumHeroCard extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const PremiumHeroCard({
    super.key,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<PremiumHeroCard> createState() => _PremiumHeroCardState();
}

class _PremiumHeroCardState extends State<PremiumHeroCard>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: AppRadius.roundedLg,
          boxShadow: [
            BoxShadow(
              color: AppColors.brandPrimary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Mesh Gradient Background (Simplified version of Aurora)
            _buildMeshBackground(),

            // Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  _buildPulsingPlayButton(),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'START WORKOUT',
                          style: AppTypography.displaySmall.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Spacing.vXxs,
                        Text(
                          'Track your progress and break PRs',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.black.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Floating Dumbbell with rotation
            Positioned(
              right: -20,
              bottom: -20,
              child: AnimatedBuilder(
                animation: _rotateController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotateController.value * 2 * math.pi * 0.05,
                    child: Icon(
                      LucideIcons.dumbbell,
                      size: 160,
                      color: Colors.black.withValues(alpha: 0.07),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeshBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brandPrimary,
            Color(0xFF81ECAD), // Soft lime-green
            Color(0xFF2DD4BF), // Teal
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: _buildBlurCircle(200, Colors.white.withValues(alpha: 0.2)),
          ),
          Positioned(
            bottom: -80,
            right: -20,
            child: _buildBlurCircle(250, Colors.black.withValues(alpha: 0.1)),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildPulsingPlayButton() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer Glow Ring
            Container(
              width: 60 + (_pulseController.value * 12),
              height: 60 + (_pulseController.value * 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black
                      .withValues(alpha: 0.2 - (_pulseController.value * 0.1)),
                  width: 2,
                ),
              ),
            ),
            // Inner Button
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.play,
                color: AppColors.brandPrimary,
                size: 24,
              ),
            ),
          ],
        );
      },
    );
  }
}

// =============================================================================
// 4. ANIMATED COUNTER
// =============================================================================

class AnimatedCounter extends StatelessWidget {
  final num value;
  final TextStyle style;
  final String suffix;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style = AppTypography.displaySmall,
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: const Duration(seconds: 1),
      curve: Curves.easeOutExpo,
      builder: (context, val, child) {
        String display;
        if (value is int) {
          display = val.toInt().toString();
        } else {
          display = val.toStringAsFixed(1);
        }
        return Text(
          '$display$suffix',
          style: style,
        );
      },
    );
  }
}

// =============================================================================
// 5. PREMIUM STAT CARD
// =============================================================================

class PremiumStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final double height;
  final double? width;
  final VoidCallback? onTap;

  const PremiumStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.accentColor = AppColors.brandPrimary,
    this.height = 180,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: AppRadius.roundedLg,
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Accent Glow
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      borderRadius: AppRadius.roundedMd,
                    ),
                    child: Icon(icon, size: 16, color: accentColor),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: AppTypography.overline.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Spacing.vXxs,
                  Text(
                    value,
                    style: AppTypography.headlineMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacing.vXxs,
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 6. GRADIENT AREA CHART WRAPPER
// =============================================================================

class GradientAreaChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double width;
  final double height;
  final Color color;

  const GradientAreaChart({
    super.key,
    required this.spots,
    this.width = double.infinity,
    this.height = 100,
    this.color = AppColors.brandPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: spots.isNotEmpty ? spots.length.toDouble() - 1 : 1,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: color,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.3),
                    color.withValues(alpha: 0.0),
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

// =============================================================================
// 7. PREMIUM GOAL CARD
// =============================================================================

class PremiumGoalCard extends StatelessWidget {
  final int count;
  final int goal;
  final double? width;
  final double height;

  const PremiumGoalCard({
    super.key,
    required this.count,
    required this.goal,
    this.width,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal > 0 ? (count / goal).clamp(0.0, 1.0) : 0.0;
    final isCompleted = progress >= 1.0;

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.roundedLg,
        border: Border.all(
          color: isCompleted ? AppColors.brandPrimary : AppColors.border,
          width: isCompleted ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          if (isCompleted)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.brandPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.check,
                    size: 12, color: Colors.black),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'GOAL',
                      style: AppTypography.overline.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Icon(
                      LucideIcons.target,
                      size: 14,
                      color: isCompleted
                          ? AppColors.brandPrimary
                          : AppColors.textMuted,
                    ),
                  ],
                ),
                const Spacer(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progress),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return CircularProgressIndicator(
                            value: value,
                            strokeWidth: 8,
                            backgroundColor: AppColors.bgCardHover,
                            color: AppColors.brandPrimary,
                            strokeCap: StrokeCap.round,
                          );
                        },
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedCounter(
                          value: count,
                          style: AppTypography.headlineMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '/$goal',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  isCompleted ? 'CHAMPION! 🎉' : '${goal - count} more to go',
                  style: AppTypography.labelSmall.copyWith(
                    color: isCompleted
                        ? AppColors.brandPrimary
                        : AppColors.textSecondary,
                    fontWeight:
                        isCompleted ? FontWeight.bold : FontWeight.normal,
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

// =============================================================================
// 8. HORIZONTAL HISTORY SCROLLER
// =============================================================================

class HorizontalHistoryScroller extends StatelessWidget {
  final List<WorkoutHistory> history;
  final Function(WorkoutHistory) onTap;

  const HorizontalHistoryScroller({
    super.key,
    required this.history,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: AppRadius.roundedLg,
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Text('No history yet. Start training!',
              style: TextStyle(color: AppColors.textMuted)),
        ),
      );
    }

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final session = history[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => onTap(session),
              child: Container(
                width: 260,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: AppRadius.roundedLg,
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: _getAccentColor(session.name),
                        borderRadius: AppRadius.roundedFull,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.name,
                            style: AppTypography.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${session.exercises.length} Exercises • ${session.totalVolume.round()} kg',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(LucideIcons.calendar,
                                  size: 12, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                _getTimeAgo(session.date),
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                              if (session.prCount > 0) ...[
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.brandSecondary
                                        .withValues(alpha: 0.1),
                                    borderRadius: AppRadius.roundedXs,
                                  ),
                                  child: Text(
                                    '${session.prCount} PR',
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.brandSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getAccentColor(String name) {
    final n = name.toLowerCase();
    if (n.contains('push')) return const Color(0xFFF43F5E); // Rose
    if (n.contains('pull')) return const Color(0xFF3B82F6); // Blue
    if (n.contains('legs')) return const Color(0xFF10B981); // Emerald
    if (n.contains('back')) return const Color(0xFF8B5CF6); // Violet
    if (n.contains('chest')) return const Color(0xFFF59E0B); // Amber
    return AppColors.brandPrimary;
  }

  String _getTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}';
  }
}
