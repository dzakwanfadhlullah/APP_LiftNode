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
