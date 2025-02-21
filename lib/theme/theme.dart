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
      primary: Color(0xff005ab5),
      surfaceTint: Color(0xff055db8),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff3174d0),
      onPrimaryContainer: Color(0xfffefcff),
      secondary: Color(0xff4b5f83),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffc1d5ff),
      onSecondaryContainer: Color(0xff485c80),
      tertiary: Color(0xff316571),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffbcf1ff),
      onTertiaryContainer: Color(0xff3b6f7b),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff191c21),
      onSurfaceVariant: Color(0xff424752),
      outline: Color(0xff727783),
      outlineVariant: Color(0xffc2c6d4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3037),
      inversePrimary: Color(0xffaac7ff),
      primaryFixed: Color(0xffd6e3ff),
      onPrimaryFixed: Color(0xff001b3e),
      primaryFixedDim: Color(0xffaac7ff),
      onPrimaryFixedVariant: Color(0xff00458e),
      secondaryFixed: Color(0xffd6e3ff),
      onSecondaryFixed: Color(0xff021b3c),
      secondaryFixedDim: Color(0xffb2c7f1),
      onSecondaryFixedVariant: Color(0xff33476a),
      tertiaryFixed: Color(0xffb6ebf9),
      onTertiaryFixed: Color(0xff001f25),
      tertiaryFixedDim: Color(0xff9bcfdc),
      onTertiaryFixedVariant: Color(0xff134d59),
      surfaceDim: Color(0xffd8d9e2),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3fb),
      surfaceContainer: Color(0xffecedf6),
      surfaceContainerHigh: Color(0xffe7e8f0),
      surfaceContainerHighest: Color(0xffe1e2ea),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00356f),
      surfaceTint: Color(0xff055db8),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff266cc8),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff213658),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff596d93),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003c47),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff417481),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff0e1117),
      onSurfaceVariant: Color(0xff313641),
      outline: Color(0xff4d525e),
      outlineVariant: Color(0xff686d79),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3037),
      inversePrimary: Color(0xffaac7ff),
      primaryFixed: Color(0xff266cc8),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff0053a8),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff596d93),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff415579),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff417481),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff265c68),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc5c6ce),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3fb),
      surfaceContainer: Color(0xffe7e8f0),
      surfaceContainerHigh: Color(0xffdbdce5),
      surfaceContainerHighest: Color(0xffd0d1d9),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002b5d),
      surfaceTint: Color(0xff055db8),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff004892),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff162c4e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff35496d),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00313a),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff17505b),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff272c37),
      outlineVariant: Color(0xff444955),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3037),
      inversePrimary: Color(0xffaac7ff),
      primaryFixed: Color(0xff004892),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003269),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff35496d),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff1e3355),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff17505b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff003842),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb7b8c0),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff0f9),
      surfaceContainer: Color(0xffe1e2ea),
      surfaceContainerHigh: Color(0xffd3d4dc),
      surfaceContainerHighest: Color(0xffc5c6ce),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffaac7ff),
      surfaceTint: Color(0xffaac7ff),
      onPrimary: Color(0xff002f65),
      primaryContainer: Color(0xff5390ef),
      onPrimaryContainer: Color(0xff002149),
      secondary: Color(0xffb2c7f1),
      onSecondary: Color(0xff1b3052),
      secondaryContainer: Color(0xff35496d),
      onSecondaryContainer: Color(0xffa4b9e2),
      tertiary: Color(0xffffffff),
      onTertiary: Color(0xff00363f),
      tertiaryContainer: Color(0xffb6ebf9),
      onTertiaryContainer: Color(0xff376c78),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff111319),
      onSurface: Color(0xffe1e2ea),
      onSurfaceVariant: Color(0xffc2c6d4),
      outline: Color(0xff8c919e),
      outlineVariant: Color(0xff424752),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2ea),
      inversePrimary: Color(0xff055db8),
      primaryFixed: Color(0xffd6e3ff),
      onPrimaryFixed: Color(0xff001b3e),
      primaryFixedDim: Color(0xffaac7ff),
      onPrimaryFixedVariant: Color(0xff00458e),
      secondaryFixed: Color(0xffd6e3ff),
      onSecondaryFixed: Color(0xff021b3c),
      secondaryFixedDim: Color(0xffb2c7f1),
      onSecondaryFixedVariant: Color(0xff33476a),
      tertiaryFixed: Color(0xffb6ebf9),
      onTertiaryFixed: Color(0xff001f25),
      tertiaryFixedDim: Color(0xff9bcfdc),
      onTertiaryFixedVariant: Color(0xff134d59),
      surfaceDim: Color(0xff111319),
      surfaceBright: Color(0xff373940),
      surfaceContainerLowest: Color(0xff0b0e14),
      surfaceContainerLow: Color(0xff191c21),
      surfaceContainer: Color(0xff1d2026),
      surfaceContainerHigh: Color(0xff272a30),
      surfaceContainerHighest: Color(0xff32353b),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcdddff),
      surfaceTint: Color(0xffaac7ff),
      onPrimary: Color(0xff002551),
      primaryContainer: Color(0xff5390ef),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffcdddff),
      onSecondary: Color(0xff0f2547),
      secondaryContainer: Color(0xff7d91b8),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffffff),
      onTertiary: Color(0xff00363f),
      tertiaryContainer: Color(0xffb6ebf9),
      onTertiaryContainer: Color(0xff154f5a),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff111319),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd8dcea),
      outline: Color(0xffadb2bf),
      outlineVariant: Color(0xff8b909d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2ea),
      inversePrimary: Color(0xff004690),
      primaryFixed: Color(0xffd6e3ff),
      onPrimaryFixed: Color(0xff00112b),
      primaryFixedDim: Color(0xffaac7ff),
      onPrimaryFixedVariant: Color(0xff00356f),
      secondaryFixed: Color(0xffd6e3ff),
      onSecondaryFixed: Color(0xff00112b),
      secondaryFixedDim: Color(0xffb2c7f1),
      onSecondaryFixedVariant: Color(0xff213658),
      tertiaryFixed: Color(0xffb6ebf9),
      onTertiaryFixed: Color(0xff001419),
      tertiaryFixedDim: Color(0xff9bcfdc),
      onTertiaryFixedVariant: Color(0xff003c47),
      surfaceDim: Color(0xff111319),
      surfaceBright: Color(0xff42444b),
      surfaceContainerLowest: Color(0xff05070d),
      surfaceContainerLow: Color(0xff1b1e23),
      surfaceContainer: Color(0xff25282e),
      surfaceContainerHigh: Color(0xff303239),
      surfaceContainerHighest: Color(0xff3b3e44),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffebf0ff),
      surfaceTint: Color(0xffaac7ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa4c3ff),
      onPrimaryContainer: Color(0xff000b20),
      secondary: Color(0xffebf0ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffafc3ed),
      onSecondaryContainer: Color(0xff000b20),
      tertiary: Color(0xffffffff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffb6ebf9),
      onTertiaryContainer: Color(0xff002f37),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff111319),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffebf0fe),
      outlineVariant: Color(0xffbec2d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2ea),
      inversePrimary: Color(0xff004690),
      primaryFixed: Color(0xffd6e3ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffaac7ff),
      onPrimaryFixedVariant: Color(0xff00112b),
      secondaryFixed: Color(0xffd6e3ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb2c7f1),
      onSecondaryFixedVariant: Color(0xff00112b),
      tertiaryFixed: Color(0xffb6ebf9),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff9bcfdc),
      onTertiaryFixedVariant: Color(0xff001419),
      surfaceDim: Color(0xff111319),
      surfaceBright: Color(0xff4e5057),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1d2026),
      surfaceContainer: Color(0xff2e3037),
      surfaceContainerHigh: Color(0xff393b42),
      surfaceContainerHighest: Color(0xff44474d),
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
  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
