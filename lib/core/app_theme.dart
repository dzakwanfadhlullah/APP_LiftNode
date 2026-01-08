import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =============================================================================
// PHASE 1.1: COLOR PALETTE EXPANSION
// =============================================================================

class AppColors {
  // ─────────────────────────────────────────────────────────────────────────
  // BACKGROUND COLORS
  // ─────────────────────────────────────────────────────────────────────────
  static const Color bgMain = Color(0xFF09090B);
  static const Color bgCard = Color(0xFF18181B);
  static const Color bgCardHover = Color(0xFF27272A);
  static const Color bgInput = Color(0xFF27272A);
  static const Color bgElevated = Color(0xFF1C1C1E);
  static const Color bgSurface = Color(0xFF121214);

  // ─────────────────────────────────────────────────────────────────────────
  // TEXT COLORS
  // ─────────────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFAFAFA);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textMuted = Color(0xFF52525B);
  static const Color textDisabled = Color(0xFF3F3F46);
  static const Color textInverse = Color(0xFF09090B);

  // ─────────────────────────────────────────────────────────────────────────
  // BRAND COLORS
  // ─────────────────────────────────────────────────────────────────────────
  static const Color brandPrimary = Color(0xFFB6F09C);
  static const Color brandSecondary = Color(0xFF22D3EE);
  static const Color brandTertiary = Color(0xFFA78BFA);

  // On-brand colors (for text/icons on brand backgrounds)
  static const Color onPrimary = Color(0xFF0A1F00);
  static const Color onSecondary = Color(0xFF002B33);

  // ─────────────────────────────────────────────────────────────────────────
  // SEMANTIC COLORS
  // ─────────────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF4ADE80);
  static const Color successLight = Color(0xFF22C55E);
  static const Color error = Color(0xFFF87171);
  static const Color errorLight = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFACC15);
  static const Color warningLight = Color(0xFFF59E0B);
  static const Color info = Color(0xFF38BDF8);
  static const Color infoLight = Color(0xFF0EA5E9);

  // ─────────────────────────────────────────────────────────────────────────
  // BORDER & OVERLAY
  // ─────────────────────────────────────────────────────────────────────────
  static const Color border = Color(0xFF27272A);
  static const Color borderFocused = Color(0xFF3F3F46);
  static const Color borderSubtle = Color(0xFF1E1E21);
  static const Color overlay = Color(0xB2000000);
  static const Color overlayLight = Color(0x80000000);

  // ─────────────────────────────────────────────────────────────────────────
  // GRADIENT PAIRS (for premium card backgrounds)
  // ─────────────────────────────────────────────────────────────────────────
  static const LinearGradient gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A2F23), Color(0xFF0D1A12)],
  );

  static const LinearGradient gradientSecondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF142533), Color(0xFF0A1219)],
  );

  static const LinearGradient gradientAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D1F4E), Color(0xFF150F26)],
  );

  static const LinearGradient gradientWarning = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF332B14), Color(0xFF19150A)],
  );

  static const LinearGradient gradientDanger = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF331A1A), Color(0xFF190D0D)],
  );

  // ─────────────────────────────────────────────────────────────────────────
  // PHASE 1.4 V1.4: GLASS COLORS (Glassmorphism)
  // ─────────────────────────────────────────────────────────────────────────

  // Glass backgrounds dengan berbagai opacity untuk efek frosted
  static const Color glassBgLight = Color(0x1AFFFFFF); // 10% white
  static const Color glassBgMedium = Color(0x26FFFFFF); // 15% white
  static const Color glassBgDark = Color(0x0DFFFFFF); // 5% white

  // Glass borders untuk efek depth
  static const Color glassBorderLight =
      Color(0x33FFFFFF); // 20% white (top edge)
  static const Color glassBorderDark =
      Color(0x1A000000); // 10% black (bottom edge)
  static const Color glassBorderSubtle = Color(0x0DFFFFFF); // 5% white

  // ─────────────────────────────────────────────────────────────────────────
  // PHASE 1.4 V1.4: PREMIUM GLASS GRADIENTS
  // ─────────────────────────────────────────────────────────────────────────

  // Glass gradient dengan brand primary tint
  static const LinearGradient glassGradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1AB6F09C), // brandPrimary 10%
      Color(0x0AB6F09C), // brandPrimary 4%
    ],
  );

  // Glass gradient dengan brand secondary (cyan) tint
  static const LinearGradient glassGradientSecondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1A22D3EE), // brandSecondary 10%
      Color(0x0A22D3EE), // brandSecondary 4%
    ],
  );

  // Glass gradient dengan tertiary (purple) tint
  static const LinearGradient glassGradientTertiary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1AA78BFA), // brandTertiary 10%
      Color(0x0AA78BFA), // brandTertiary 4%
    ],
  );

  // Neutral frosted glass (untuk cards biasa)
  static const LinearGradient glassGradientNeutral = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x12FFFFFF), // white 7%
      Color(0x08FFFFFF), // white 3%
    ],
  );

  // Aurora/Mesh gradient untuk backgrounds
  static const LinearGradient auroraGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0D1117), // Deep dark
      Color(0xFF0A1628), // Dark blue tint
      Color(0xFF0D1117), // Deep dark
    ],
    stops: [0.0, 0.5, 1.0],
  );
}

// =============================================================================
// PHASE 1.3: SPACING & LAYOUT TOKENS
// =============================================================================

class Spacing {
  Spacing._();

  // Base spacing unit: 4px
  static const double unit = 4.0;

  // Named spacing values
  static const double xxs = 2.0; // 2px
  static const double xs = 4.0; // 4px
  static const double sm = 8.0; // 8px
  static const double md = 16.0; // 16px
  static const double lg = 24.0; // 24px
  static const double xl = 32.0; // 32px
  static const double xxl = 48.0; // 48px
  static const double xxxl = 64.0; // 64px

  // Semantic spacing
  static const double cardPadding = 16.0;
  static const double sectionGap = 24.0;
  static const double screenPadding = 16.0;
  static const double itemGap = 12.0;
  static const double inputPadding = 12.0;

  // Widget helpers
  static const SizedBox hXxs = SizedBox(width: xxs);
  static const SizedBox hXs = SizedBox(width: xs);
  static const SizedBox hSm = SizedBox(width: sm);
  static const SizedBox hMd = SizedBox(width: md);
  static const SizedBox hLg = SizedBox(width: lg);
  static const SizedBox hXl = SizedBox(width: xl);

  static const SizedBox vXxs = SizedBox(height: xxs);
  static const SizedBox vXs = SizedBox(height: xs);
  static const SizedBox vSm = SizedBox(height: sm);
  static const SizedBox vMd = SizedBox(height: md);
  static const SizedBox vLg = SizedBox(height: lg);
  static const SizedBox vXl = SizedBox(height: xl);
  static const SizedBox vXxl = SizedBox(height: xxl);

  // EdgeInsets helpers
  static const EdgeInsets paddingCard = EdgeInsets.all(cardPadding);
  static const EdgeInsets paddingScreen = EdgeInsets.all(screenPadding);
  static const EdgeInsets paddingHorizontalLg =
      EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalMd =
      EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingBadge =
      EdgeInsets.symmetric(horizontal: sm, vertical: xxs);
}

// =============================================================================
// PHASE 1.4: ANIMATION TOKENS
// =============================================================================

class AppAnimations {
  AppAnimations._();

  // Duration constants
  static const Duration instant = Duration(milliseconds: 0);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration slower = Duration(milliseconds: 500);
  static const Duration slowest = Duration(milliseconds: 750);

  // Semantic durations
  static const Duration buttonPress = fast;
  static const Duration cardHover = fast;
  static const Duration pageTransition = normal;
  static const Duration modalOpen = slow;
  static const Duration listItemStagger = Duration(milliseconds: 50);

  // Curve constants
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve bouncy = Curves.elasticOut;
  static const Curve smooth = Curves.fastOutSlowIn;
  static const Curve snappy = Curves.easeOutCubic;

  // Semantic curves
  static const Curve defaultCurve = easeInOut;
  static const Curve enterCurve = easeOut;
  static const Curve exitCurve = easeIn;
  static const Curve emphasizedCurve = smooth;
}

// =============================================================================
// PHASE 2.12: CUSTOM PAGE ROUTE TRANSITIONS
// =============================================================================

class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  SlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = AppAnimations.snappy;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: AppAnimations.pageTransition,
        );
}

// =============================================================================
// PHASE 1.2: TYPOGRAPHY SYSTEM REFINEMENT
// =============================================================================

class AppTypography {
  AppTypography._();

  // Display styles (headlines)
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // Headline styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // Title styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  // Body styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  // Label styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  // Special styles
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.4,
    color: AppColors.textMuted,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    height: 1.5,
    color: AppColors.textMuted,
  );

  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle stat = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
    color: AppColors.textPrimary,
  );

  static const TextStyle statSmall = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.2,
    color: AppColors.textPrimary,
  );
}

// =============================================================================
// BORDER RADIUS TOKENS
// =============================================================================

class AppRadius {
  AppRadius._();

  static const double none = 0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double full = 9999.0;

  // BorderRadius helpers
  static const BorderRadius roundedXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius roundedSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius roundedMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius roundedLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius roundedXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius roundedXxl = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius roundedFull =
      BorderRadius.all(Radius.circular(full));
}

// =============================================================================
// SHADOW TOKENS
// =============================================================================

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> none = [];

  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];

  static List<BoxShadow> glow(Color color,
      {double blur = 16, double spread = 0}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.4),
        blurRadius: blur,
        spreadRadius: spread,
      ),
    ];
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PHASE 1.4 V1.4: AMBIENT SHADOWS (dengan warna accent)
  // ─────────────────────────────────────────────────────────────────────────

  /// Ambient shadow dengan warna accent untuk efek glow pada hover/focus
  /// [accentColor] - warna yang akan dijadikan ambient glow
  /// [intensity] - kekuatan glow (0.0 - 1.0, default 0.3)
  /// [blur] - blur radius (default 20)
  static List<BoxShadow> ambient(
    Color accentColor, {
    double intensity = 0.3,
    double blur = 20,
  }) {
    return [
      // Layer 1: Soft glow (far)
      BoxShadow(
        color: accentColor.withValues(alpha: intensity * 0.4),
        blurRadius: blur * 1.5,
        spreadRadius: 0,
        offset: const Offset(0, 4),
      ),
      // Layer 2: Focused glow (near)
      BoxShadow(
        color: accentColor.withValues(alpha: intensity * 0.6),
        blurRadius: blur * 0.5,
        spreadRadius: 0,
        offset: const Offset(0, 2),
      ),
    ];
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PHASE 1.4 V1.4: INNER SHADOWS (untuk pressed states)
  // ─────────────────────────────────────────────────────────────────────────

  /// Inner shadow untuk efek "pressed" atau "inset"
  /// Menggunakan BoxShadow dengan offset negatif untuk simulasi inner shadow
  static List<BoxShadow> inner({
    Color color = const Color(0x40000000),
    double blur = 4,
    double spread = 0,
  }) {
    return [
      // Top inner shadow
      BoxShadow(
        color: color,
        blurRadius: blur,
        spreadRadius: spread,
        offset: const Offset(0, 2),
        blurStyle: BlurStyle.inner,
      ),
    ];
  }

  /// Multi-layer shadow untuk efek depth yang lebih natural (Apple-style)
  /// Kombinasi 2-3 layer shadow dengan berbagai intensity
  static List<BoxShadow> elevated({int level = 1}) {
    switch (level) {
      case 0:
        return none;
      case 1:
        return [
          const BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
          const BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ];
      case 2:
        return [
          const BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
          const BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
          const BoxShadow(
            color: Color(0x26000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ];
      case 3:
      default:
        return [
          const BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
          const BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
          const BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ];
    }
  }
}

// =============================================================================
// THEME DATA
// =============================================================================

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgMain,
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme.copyWith(
              displayLarge: AppTypography.displayLarge,
              displayMedium: AppTypography.displayMedium,
              displaySmall: AppTypography.displaySmall,
              headlineLarge: AppTypography.headlineLarge,
              headlineMedium: AppTypography.headlineMedium,
              headlineSmall: AppTypography.headlineSmall,
              titleLarge: AppTypography.titleLarge,
              titleMedium: AppTypography.titleMedium,
              titleSmall: AppTypography.titleSmall,
              bodyLarge: AppTypography.bodyLarge,
              bodyMedium: AppTypography.bodyMedium,
              bodySmall: AppTypography.bodySmall,
              labelLarge: AppTypography.labelLarge,
              labelMedium: AppTypography.labelMedium,
              labelSmall: AppTypography.labelSmall,
            ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.brandPrimary,
        secondary: AppColors.brandSecondary,
        tertiary: AppColors.brandTertiary,
        surface: AppColors.bgCard,
        error: AppColors.error,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.onSecondary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textPrimary,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.roundedLg,
          side: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandPrimary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
              horizontal: Spacing.lg, vertical: Spacing.md),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.roundedMd,
          ),
          textStyle: AppTypography.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(
              horizontal: Spacing.lg, vertical: Spacing.md),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.roundedMd,
          ),
          textStyle: AppTypography.button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgInput,
        contentPadding: const EdgeInsets.all(Spacing.inputPadding),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: BorderSide(color: AppColors.brandPrimary, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.roundedMd,
          borderSide: BorderSide(color: AppColors.error),
        ),
        labelStyle:
            AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        hintStyle:
            AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: Spacing.md,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.bgElevated,
        contentTextStyle: AppTypography.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.roundedMd,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// =============================================================================
// PHASE 1.4 V1.4: GLASS DECORATION
// Helper class untuk membuat glassmorphism BoxDecoration dengan mudah
// =============================================================================

enum GlassVariant {
  /// Full frosted glass dengan blur effect
  frosted,

  /// Solid colored dengan gradient overlay
  solid,

  /// Gradient background tanpa blur
  gradient,

  /// Border only, transparent background
  outlined,
}

class GlassDecoration {
  GlassDecoration._();

  /// Membuat BoxDecoration untuk efek glassmorphism
  ///
  /// [variant] - Tipe glass effect yang diinginkan
  /// [accentColor] - Warna accent untuk tint/glow (optional)
  /// [borderRadius] - Border radius, default 20
  /// [withBorder] - Apakah menampilkan border, default true
  /// [opacity] - Opacity background (0.0-1.0), default 0.1
  static BoxDecoration create({
    GlassVariant variant = GlassVariant.frosted,
    Color? accentColor,
    double borderRadius = 20,
    bool withBorder = true,
    double opacity = 0.1,
  }) {
    final radius = BorderRadius.circular(borderRadius);

    switch (variant) {
      case GlassVariant.frosted:
        return BoxDecoration(
          color: Colors.white.withValues(alpha: opacity),
          borderRadius: radius,
          border: withBorder ? _createGlassBorder() : null,
        );

      case GlassVariant.solid:
        return BoxDecoration(
          color: (accentColor ?? AppColors.bgCard).withValues(alpha: 0.9),
          borderRadius: radius,
          border: withBorder
              ? Border.all(
                  color: AppColors.border,
                  width: 1,
                )
              : null,
          boxShadow: AppShadows.elevated(level: 1),
        );

      case GlassVariant.gradient:
        return BoxDecoration(
          gradient: accentColor != null
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor.withValues(alpha: 0.15),
                    accentColor.withValues(alpha: 0.05),
                  ],
                )
              : AppColors.glassGradientNeutral,
          borderRadius: radius,
          border: withBorder ? _createGlassBorder() : null,
        );

      case GlassVariant.outlined:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: radius,
          border: Border.all(
            color: accentColor?.withValues(alpha: 0.5) ??
                AppColors.glassBorderLight,
            width: 1.5,
          ),
        );
    }
  }

  /// Membuat border dengan efek depth (terang di atas, gelap di bawah)
  static Border _createGlassBorder() {
    return const Border(
      top: BorderSide(color: AppColors.glassBorderLight, width: 1),
      left: BorderSide(color: AppColors.glassBorderSubtle, width: 1),
      right: BorderSide(color: AppColors.glassBorderDark, width: 1),
      bottom: BorderSide(color: AppColors.glassBorderDark, width: 1),
    );
  }

  /// Border gradient untuk efek premium
  /// Digunakan dengan CustomPainter atau ShaderMask
  static LinearGradient get borderGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.glassBorderLight,
          AppColors.glassBorderDark,
        ],
      );

  /// Preset decorations untuk penggunaan cepat
  static BoxDecoration get cardFrosted => create(variant: GlassVariant.frosted);
  static BoxDecoration get cardSolid => create(variant: GlassVariant.solid);
  static BoxDecoration get cardGradient =>
      create(variant: GlassVariant.gradient);
  static BoxDecoration get cardOutlined =>
      create(variant: GlassVariant.outlined);

  /// Card dengan accent color tertentu
  static BoxDecoration primaryCard() => create(
        variant: GlassVariant.gradient,
        accentColor: AppColors.brandPrimary,
      );

  static BoxDecoration secondaryCard() => create(
        variant: GlassVariant.gradient,
        accentColor: AppColors.brandSecondary,
      );

  static BoxDecoration tertiaryCard() => create(
        variant: GlassVariant.gradient,
        accentColor: AppColors.brandTertiary,
      );
}

// =============================================================================
// PHASE 1.4 V1.4: DEPTH TOKENS
// Sistem elevation yang konsisten untuk kedalaman visual
// =============================================================================

enum DepthLevel {
  /// Level 0: Surface - No elevation (flat)
  surface,

  /// Level 1: Raised - Slight elevation (+8dp shadow)
  raised,

  /// Level 2: Floating - Medium elevation (+16dp shadow)
  floating,

  /// Level 3: Modal - High elevation (+24dp shadow)
  modal,
}

class DepthTokens {
  DepthTokens._();

  /// Mendapatkan BoxShadow berdasarkan DepthLevel
  static List<BoxShadow> getShadow(DepthLevel level) {
    switch (level) {
      case DepthLevel.surface:
        return AppShadows.none;
      case DepthLevel.raised:
        return AppShadows.elevated(level: 1);
      case DepthLevel.floating:
        return AppShadows.elevated(level: 2);
      case DepthLevel.modal:
        return AppShadows.elevated(level: 3);
    }
  }

  /// Mendapatkan BoxShadow dengan ambient glow berdasarkan level
  static List<BoxShadow> getShadowWithGlow(
      DepthLevel level, Color accentColor) {
    final baseShadows = getShadow(level);
    if (level == DepthLevel.surface) return baseShadows;

    // Combine base shadows dengan ambient glow
    return [
      ...baseShadows,
      ...AppShadows.ambient(
        accentColor,
        intensity: _getGlowIntensity(level),
        blur: _getGlowBlur(level),
      ),
    ];
  }

  static double _getGlowIntensity(DepthLevel level) {
    switch (level) {
      case DepthLevel.surface:
        return 0.0;
      case DepthLevel.raised:
        return 0.15;
      case DepthLevel.floating:
        return 0.25;
      case DepthLevel.modal:
        return 0.35;
    }
  }

  static double _getGlowBlur(DepthLevel level) {
    switch (level) {
      case DepthLevel.surface:
        return 0;
      case DepthLevel.raised:
        return 12;
      case DepthLevel.floating:
        return 20;
      case DepthLevel.modal:
        return 30;
    }
  }

  /// Mendapatkan background color dengan opacity berdasarkan level
  /// Semakin tinggi level, semakin solid warnanya
  static Color getBackgroundColor(DepthLevel level, {Color? customColor}) {
    final baseColor = customColor ?? AppColors.bgCard;
    switch (level) {
      case DepthLevel.surface:
        return baseColor;
      case DepthLevel.raised:
        return baseColor.withValues(alpha: 0.95);
      case DepthLevel.floating:
        return baseColor;
      case DepthLevel.modal:
        return AppColors.bgElevated;
    }
  }

  /// Mendapatkan complete BoxDecoration untuk level tertentu
  static BoxDecoration getDecoration(
    DepthLevel level, {
    Color? accentColor,
    double borderRadius = 16,
    bool withGlow = false,
  }) {
    return BoxDecoration(
      color: getBackgroundColor(level),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: level == DepthLevel.modal
            ? AppColors.borderFocused
            : AppColors.border,
        width: 1,
      ),
      boxShadow: withGlow && accentColor != null
          ? getShadowWithGlow(level, accentColor)
          : getShadow(level),
    );
  }
}

// =============================================================================
// PHASE 1.4 V1.4: GLASS BLUR FILTER
// Helper untuk BackdropFilter dengan blur settings
// =============================================================================

class GlassBlur {
  GlassBlur._();

  /// Blur amount presets
  static const double light = 10.0;
  static const double medium = 15.0;
  static const double heavy = 25.0;
  static const double extreme = 40.0;

  /// Membuat ImageFilter untuk BackdropFilter
  static ImageFilter blur({double sigma = medium}) {
    return ImageFilter.blur(sigmaX: sigma, sigmaY: sigma);
  }

  /// Preset blur filters
  static ImageFilter get blurLight => blur(sigma: light);
  static ImageFilter get blurMedium => blur(sigma: medium);
  static ImageFilter get blurHeavy => blur(sigma: heavy);
  static ImageFilter get blurExtreme => blur(sigma: extreme);
}
