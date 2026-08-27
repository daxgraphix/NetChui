import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const red = Color(0xFFFF3B3B);
  static const green = Color(0xFF34C759);
  static const blue = Color(0xFF007AFF);
  static const orange = Color(0xFFFF9500);
  static const purple = Color(0xFFAF52DE);
  static const darkGrey = Color(0xFF0F0F0F);
  static const lightGrey = Color(0xFFF2F2F7);

  // Modern UI Colors
  static const darkBackground = Color(0xFF080809);
  static const darkSurface = Color(0xFF111114);
  static const darkSurfaceVariant = Color(0xFF16161A); // Slightly lighter for contrast
  static const lightBackground = Color(0xFFF8FAFC);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFF1F5F9);

  static const darkText = Color(0xFFF8FAFC);
  static const lightText = Color(0xFF0F172A);
  static const darkMuted = Color(0xFF94A3B8);
  static const lightMuted = Color(0xFF64748B); // Slightly darker for better light mode visibility

  static const accent = Color(0xFFFF3B3B);
  static const secondary = Color(0xFF3B82F6);
  static const tertiary = Color(0xFF8B5CF6);
  static const success = Color(0xFF10B981); // Refined success green
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF0EA5E9);

  static const gradientPrimary = [Color(0xFFFF3B3B), Color(0xFFFF6B6B)];
  static const gradientSecondary = [Color(0xFF3B82F6), Color(0xFF60A5FA)];
  static const gradientGlass = [Color(0x1AFFFFFF), Color(0x05FFFFFF)];
  
  static const successGradient = [Color(0xFF22C55E), Color(0xFF4ADE80)];
  static const warningGradient = [Color(0xFFF59E0B), Color(0xFFFBBF24)];
  static const infoGradient = [Color(0xFF0EA5E9), Color(0xFF38BDF8)];
}

abstract final class Spacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
}

abstract final class AppTheme {
  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        background: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        text: AppColors.darkText,
        accent: AppColors.accent,
      );

  static ThemeData light() => _build(
        brightness: Brightness.light,
        background: AppColors.lightBackground,
        surface: AppColors.lightSurface,
        text: AppColors.lightText,
        accent: AppColors.accent,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color text,
    required Color accent,
  }) {
    final isDark = brightness == Brightness.dark;
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: brightness,
        primary: accent,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        tertiary: AppColors.tertiary,
        error: AppColors.accent,
        surface: surface,
        onSurface: text,
        onSurfaceVariant: isDark ? AppColors.darkMuted : AppColors.lightMuted,
        outline: text.withValues(alpha: isDark ? 0.12 : 0.2),
        outlineVariant: text.withValues(alpha: isDark ? 0.06 : 0.1),
        surfaceContainerHighest: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
      ),
      iconTheme: IconThemeData(
        color: text,
        size: 24,
        opacity: 1.0,
      ),
      primaryIconTheme: const IconThemeData(
        color: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: isDark 
              ? Colors.white.withValues(alpha: 0.1) 
              : Colors.black.withValues(alpha: 0.08)
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: text.withValues(alpha: 0.08),
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: text,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: text, size: 22),
        titleTextStyle: GoogleFonts.outfit(
          color: text,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          textStyle: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          side: BorderSide(color: text.withValues(alpha: 0.2)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: accent.withValues(alpha: 0.1),
        indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: accent, size: 24);
          }
          return IconThemeData(color: text.withValues(alpha: 0.6), size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: accent,
            );
          }
          return GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: text.withValues(alpha: 0.5),
          );
        }),
      ),
    );


    return base.copyWith(
      textTheme: GoogleFonts.outfitTextTheme(base.textTheme).apply(
        bodyColor: text,
        displayColor: text,
      ),
      extensions: [
        NetChuiColors(
          background: background,
          surface: surface,
          text: text,
          accent: accent,
          secondary: isDark ? AppColors.secondary : AppColors.secondary,
          muted: isDark ? AppColors.darkMuted : AppColors.lightMuted,
          subtle: text.withValues(alpha: isDark ? 0.35 : 0.45),
          card: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurface,
          border: text.withValues(alpha: isDark ? 0.08 : 0.06),
          glass: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.015),
          success: AppColors.success,
          warning: AppColors.warning,
          info: AppColors.info,
          tertiary: AppColors.tertiary,
        ),
      ],
    );
  }
}

class NetChuiColors extends ThemeExtension<NetChuiColors> {
  const NetChuiColors({
    required this.background,
    required this.surface,
    required this.text,
    required this.accent,
    required this.secondary,
    required this.muted,
    required this.subtle,
    required this.card,
    required this.border,
    required this.glass,
    required this.success,
    required this.warning,
    required this.info,
    required this.tertiary,
  });

  final Color background;
  final Color surface;
  final Color text;
  final Color accent;
  final Color secondary;
  final Color muted;
  final Color subtle;
  final Color card;
  final Color border;
  final Color glass;
  final Color success;
  final Color warning;
  final Color info;
  final Color tertiary;

  @override
  NetChuiColors copyWith({
    Color? background,
    Color? surface,
    Color? text,
    Color? accent,
    Color? secondary,
    Color? muted,
    Color? subtle,
    Color? card,
    Color? border,
    Color? glass,
    Color? success,
    Color? warning,
    Color? info,
    Color? tertiary,
  }) {
    return NetChuiColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      text: text ?? this.text,
      accent: accent ?? this.accent,
      secondary: secondary ?? this.secondary,
      muted: muted ?? this.muted,
      subtle: subtle ?? this.subtle,
      card: card ?? this.card,
      border: border ?? this.border,
      glass: glass ?? this.glass,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      tertiary: tertiary ?? this.tertiary,
    );
  }

  @override
  NetChuiColors lerp(ThemeExtension<NetChuiColors>? other, double t) {
    if (other is! NetChuiColors) {
      return this;
    }
    return NetChuiColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      text: Color.lerp(text, other.text, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      subtle: Color.lerp(subtle, other.subtle, t)!,
      card: Color.lerp(card, other.card, t)!,
      border: Color.lerp(border, other.border, t)!,
      glass: Color.lerp(glass, other.glass, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
    );
  }
}

extension NetChuiTheme on BuildContext {
  NetChuiColors get netChui => Theme.of(this).extension<NetChuiColors>()!;

  TextTheme get netChuiText => Theme.of(this).textTheme;
  Color get netChuiScaffold => Theme.of(this).scaffoldBackgroundColor;
}
