import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class MaterialTheme {
  final String bodyFontString = "Raleway";
  final String displayFontString = "Raleway";

  late TextTheme textTheme;
  late TextTheme baseTextTheme;
  late TextTheme bodyTextTheme;
  late TextTheme displayTextTheme;

  MaterialTheme(BuildContext context) {
    TextTheme baseTextTheme = Theme.of(context).textTheme;
    TextTheme bodyTextTheme = GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
    TextTheme displayTextTheme = GoogleFonts.getTextTheme(displayFontString, baseTextTheme);
    textTheme = displayTextTheme.copyWith(
      bodyLarge: bodyTextTheme.bodyLarge,
      bodyMedium: bodyTextTheme.bodyMedium,
      bodySmall: bodyTextTheme.bodySmall,
      labelLarge: bodyTextTheme.labelLarge,
      labelMedium: bodyTextTheme.labelMedium,
      labelSmall: bodyTextTheme.labelSmall,
    );
  }
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color.fromARGB(255, 93, 115, 226),
      surfaceTint: Color(0xff3f54bf),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff576cd7),
      onPrimaryContainer: Color(0xfffffbff),
      secondary: Color(0xff555c86),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffc5ccfd),
      onSecondaryContainer: Color(0xff4e557f),
      tertiary: Color(0xff506071),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffE7EFEE),
      onTertiaryContainer: Color(0xff596a7b),
      error: Color(0xffb41c1b),
      onError: Color(0xffffffff),
      errorContainer: Color.fromARGB(255, 211, 82, 75),
      onErrorContainer: Color(0xfffffbff),
      surface: Color(0xfffbf8ff),
      onSurface: Color(0xff1a1b22),
      onSurfaceVariant: Color(0xff444653),
      outline: Color(0xff757684),
      outlineVariant: Color(0xffc5c5d5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3037),
      inversePrimary: Color(0xffbac3ff),
      primaryFixed: Color(0xffdee1ff),
      onPrimaryFixed: Color(0xff001159),
      primaryFixedDim: Color(0xffbac3ff),
      onPrimaryFixedVariant: Color(0xff233ba6),
      secondaryFixed: Color(0xffdee1ff),
      onSecondaryFixed: Color(0xff10183f),
      secondaryFixedDim: Color(0xffbdc4f4),
      onSecondaryFixedVariant: Color(0xff3d446d),
      tertiaryFixed: Color(0xffd3e4f9),
      onTertiaryFixed: Color(0xff0c1d2c),
      tertiaryFixedDim: Color(0xffb7c8dc),
      onTertiaryFixedVariant: Color(0xff384859),
      surfaceDim: Color(0xffdad9e2),
      surfaceBright: Color(0xfffbf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f2fc),
      surfaceContainer: Color(0xffeeedf6),
      surfaceContainerHigh: Color(0xffe9e7f1),
      surfaceContainerHighest: Color(0xffe3e1eb),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff082796),
      surfaceTint: Color(0xff3f54bf),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4f64cf),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2c335b),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff636a96),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff283848),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff5e6f81),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcd302a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffbf8ff),
      onSurface: Color(0xff101117),
      onSurfaceVariant: Color(0xff343542),
      outline: Color(0xff50525f),
      outlineVariant: Color(0xff6b6c7a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3037),
      inversePrimary: Color(0xffbac3ff),
      primaryFixed: Color(0xff4f64cf),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff344ab5),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff636a96),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4b527c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff5e6f81),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff465667),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc7c5cf),
      surfaceBright: Color(0xfffbf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f2fc),
      surfaceContainer: Color(0xffe9e7f1),
      surfaceContainerHigh: Color(0xffdddce5),
      surfaceContainerHighest: Color(0xffd2d0da),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff001d83),
      surfaceTint: Color(0xff3f54bf),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff263da9),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff222950),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff3f476f),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff1d2e3d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff3b4b5b),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000b),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffbf8ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff2a2b37),
      outlineVariant: Color(0xff474855),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3037),
      inversePrimary: Color(0xffbac3ff),
      primaryFixed: Color(0xff263da9),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff002293),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff3f476f),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff283057),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff3b4b5b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff243444),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb9b8c1),
      surfaceBright: Color(0xfffbf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1eff9),
      surfaceContainer: Color(0xffe3e1eb),
      surfaceContainerHigh: Color(0xffd5d3dd),
      surfaceContainerHighest: Color(0xffc7c5cf),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbac3ff),
      surfaceTint: Color(0xffbac3ff),
      onPrimary: Color(0xff00208d),
      primaryContainer: Color(0xff7489f6),
      onPrimaryContainer: Color(0xff000326),
      secondary: Color(0xffbdc4f4),
      onSecondary: Color(0xff262e55),
      secondaryContainer: Color(0xff3d446d),
      onSecondaryContainer: Color(0xffabb2e2),
      tertiary: Color(0xffffffff),
      onTertiary: Color(0xff223242),
      tertiaryContainer: Color(0xffd3e4f9),
      onTertiaryContainer: Color(0xff566678),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff5c0004),
      surface: Color(0xff121319),
      onSurface: Color(0xffe3e1eb),
      onSurfaceVariant: Color(0xffc5c5d5),
      outline: Color(0xff8f909e),
      outlineVariant: Color(0xff444653),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e1eb),
      inversePrimary: Color(0xff3f54bf),
      primaryFixed: Color(0xffdee1ff),
      onPrimaryFixed: Color(0xff001159),
      primaryFixedDim: Color(0xffbac3ff),
      onPrimaryFixedVariant: Color(0xff233ba6),
      secondaryFixed: Color(0xffdee1ff),
      onSecondaryFixed: Color(0xff10183f),
      secondaryFixedDim: Color(0xffbdc4f4),
      onSecondaryFixedVariant: Color(0xff3d446d),
      tertiaryFixed: Color(0xffd3e4f9),
      onTertiaryFixed: Color(0xff0c1d2c),
      tertiaryFixedDim: Color(0xffb7c8dc),
      onTertiaryFixedVariant: Color(0xff384859),
      surfaceDim: Color(0xff121319),
      surfaceBright: Color(0xff383940),
      surfaceContainerLowest: Color(0xff0d0e14),
      surfaceContainerLow: Color(0xff1a1b22),
      surfaceContainer: Color(0xff1e1f26),
      surfaceContainerHigh: Color(0xff292931),
      surfaceContainerHighest: Color(0xff34343c),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd6daff),
      surfaceTint: Color(0xffbac3ff),
      onPrimary: Color(0xff001872),
      primaryContainer: Color(0xff7489f6),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffd6daff),
      onSecondary: Color(0xff1b2349),
      secondaryContainer: Color(0xff878ebb),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffffff),
      onTertiary: Color(0xff223242),
      tertiaryContainer: Color(0xffd3e4f9),
      onTertiaryContainer: Color(0xff39495a),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff121319),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdbdbeb),
      outline: Color(0xffb0b1c0),
      outlineVariant: Color(0xff8e8f9e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e1eb),
      inversePrimary: Color(0xff253ca8),
      primaryFixed: Color(0xffdee1ff),
      onPrimaryFixed: Color(0xff00093f),
      primaryFixedDim: Color(0xffbac3ff),
      onPrimaryFixedVariant: Color(0xff082796),
      secondaryFixed: Color(0xffdee1ff),
      onSecondaryFixed: Color(0xff050d34),
      secondaryFixedDim: Color(0xffbdc4f4),
      onSecondaryFixedVariant: Color(0xff2c335b),
      tertiaryFixed: Color(0xffd3e4f9),
      onTertiaryFixed: Color(0xff021221),
      tertiaryFixedDim: Color(0xffb7c8dc),
      onTertiaryFixedVariant: Color(0xff283848),
      surfaceDim: Color(0xff121319),
      surfaceBright: Color(0xff43444b),
      surfaceContainerLowest: Color(0xff06070d),
      surfaceContainerLow: Color(0xff1c1d24),
      surfaceContainer: Color(0xff27272e),
      surfaceContainerHigh: Color(0xff313239),
      surfaceContainerHighest: Color(0xff3d3d45),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffefeeff),
      surfaceTint: Color(0xffbac3ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffb5bfff),
      onPrimaryContainer: Color(0xff000326),
      secondary: Color(0xffefeeff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffb9c0f0),
      onSecondaryContainer: Color(0xff01062f),
      tertiary: Color(0xffffffff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffd3e4f9),
      onTertiaryContainer: Color(0xff1b2b3b),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea5),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff121319),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffefeeff),
      outlineVariant: Color(0xffc1c1d1),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e1eb),
      inversePrimary: Color(0xff253ca8),
      primaryFixed: Color(0xffdee1ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffbac3ff),
      onPrimaryFixedVariant: Color(0xff00093f),
      secondaryFixed: Color(0xffdee1ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffbdc4f4),
      onSecondaryFixedVariant: Color(0xff050d34),
      tertiaryFixed: Color(0xffd3e4f9),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffb7c8dc),
      onTertiaryFixedVariant: Color(0xff021221),
      surfaceDim: Color(0xff121319),
      surfaceBright: Color(0xff4f4f57),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1e1f26),
      surfaceContainer: Color(0xff2f3037),
      surfaceContainerHigh: Color(0xff3a3b42),
      surfaceContainerHighest: Color(0xff46464e),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  static const warning = Color.fromARGB(255, 227, 168, 18);
}
