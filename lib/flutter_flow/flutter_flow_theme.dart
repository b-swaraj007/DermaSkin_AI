// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

const kThemeModeKey = '__theme_mode__';

SharedPreferences? _prefs;

abstract class FlutterFlowTheme {
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();

  static ThemeMode get themeMode {
    final darkMode = _prefs?.getBool(kThemeModeKey);
    return darkMode == null
        ? ThemeMode.system
        : darkMode
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  static void saveThemeMode(ThemeMode mode) => mode == ThemeMode.system
      ? _prefs?.remove(kThemeModeKey)
      : _prefs?.setBool(kThemeModeKey, mode == ThemeMode.dark);

  static FlutterFlowTheme of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? DarkModeTheme()
        : LightModeTheme();
  }

  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary;
  late Color secondary;
  late Color tertiary;
  late Color alternate;
  late Color primaryText;
  late Color secondaryText;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color accent1;
  late Color accent2;
  late Color accent3;
  late Color accent4;
  late Color success;
  late Color warning;
  late Color error;
  late Color info;

  late Color onPrimary;
  late Color onSecondary;
  late Color onSurface;
  late Color onError;
  late Color transparent;
  late Color accent15;
  late Color accent40;
  late Color onSecondary70;
  late Color accent60;
  late Color accent30;
  late Color onSecondary60;
  late Color primary5;
  late Color accent20;
  late Color surface70;
  late Color accent80;
  late Color onPrimary10;
  late Color onPrimary20;
  late Color success20;
  late Color onSurface80;
  late Color onPrimary5;
  late Color onPrimary60;
  late Color onPrimary30;
  late Color onPrimary40;
  late Color onPrimary27;
  late Color primary90;
  late Color secondaryText50;
  late Color background97;
  late Color surface40;
  late Color surface90;
  late Color surface80;
  late Color surface60;
  late Color success15;
  late Color error15;
  late Color divider50;
  late Color primary10;
  late Color primary30;

  FFDesignTokens get designToken => FFDesignTokens(this);

  @Deprecated('Use displaySmallFamily instead')
  String get title1Family => displaySmallFamily;
  @Deprecated('Use displaySmall instead')
  TextStyle get title1 => typography.displaySmall;
  @Deprecated('Use headlineMediumFamily instead')
  String get title2Family => typography.headlineMediumFamily;
  @Deprecated('Use headlineMedium instead')
  TextStyle get title2 => typography.headlineMedium;
  @Deprecated('Use headlineSmallFamily instead')
  String get title3Family => typography.headlineSmallFamily;
  @Deprecated('Use headlineSmall instead')
  TextStyle get title3 => typography.headlineSmall;
  @Deprecated('Use titleMediumFamily instead')
  String get subtitle1Family => typography.titleMediumFamily;
  @Deprecated('Use titleMedium instead')
  TextStyle get subtitle1 => typography.titleMedium;
  @Deprecated('Use titleSmallFamily instead')
  String get subtitle2Family => typography.titleSmallFamily;
  @Deprecated('Use titleSmall instead')
  TextStyle get subtitle2 => typography.titleSmall;
  @Deprecated('Use bodyMediumFamily instead')
  String get bodyText1Family => typography.bodyMediumFamily;
  @Deprecated('Use bodyMedium instead')
  TextStyle get bodyText1 => typography.bodyMedium;
  @Deprecated('Use bodySmallFamily instead')
  String get bodyText2Family => typography.bodySmallFamily;
  @Deprecated('Use bodySmall instead')
  TextStyle get bodyText2 => typography.bodySmall;

  String get displayLargeFamily => typography.displayLargeFamily;
  bool get displayLargeIsCustom => typography.displayLargeIsCustom;
  TextStyle get displayLarge => typography.displayLarge;
  String get displayMediumFamily => typography.displayMediumFamily;
  bool get displayMediumIsCustom => typography.displayMediumIsCustom;
  TextStyle get displayMedium => typography.displayMedium;
  String get displaySmallFamily => typography.displaySmallFamily;
  bool get displaySmallIsCustom => typography.displaySmallIsCustom;
  TextStyle get displaySmall => typography.displaySmall;
  String get headlineLargeFamily => typography.headlineLargeFamily;
  bool get headlineLargeIsCustom => typography.headlineLargeIsCustom;
  TextStyle get headlineLarge => typography.headlineLarge;
  String get headlineMediumFamily => typography.headlineMediumFamily;
  bool get headlineMediumIsCustom => typography.headlineMediumIsCustom;
  TextStyle get headlineMedium => typography.headlineMedium;
  String get headlineSmallFamily => typography.headlineSmallFamily;
  bool get headlineSmallIsCustom => typography.headlineSmallIsCustom;
  TextStyle get headlineSmall => typography.headlineSmall;
  String get titleLargeFamily => typography.titleLargeFamily;
  bool get titleLargeIsCustom => typography.titleLargeIsCustom;
  TextStyle get titleLarge => typography.titleLarge;
  String get titleMediumFamily => typography.titleMediumFamily;
  bool get titleMediumIsCustom => typography.titleMediumIsCustom;
  TextStyle get titleMedium => typography.titleMedium;
  String get titleSmallFamily => typography.titleSmallFamily;
  bool get titleSmallIsCustom => typography.titleSmallIsCustom;
  TextStyle get titleSmall => typography.titleSmall;
  String get labelLargeFamily => typography.labelLargeFamily;
  bool get labelLargeIsCustom => typography.labelLargeIsCustom;
  TextStyle get labelLarge => typography.labelLarge;
  String get labelMediumFamily => typography.labelMediumFamily;
  bool get labelMediumIsCustom => typography.labelMediumIsCustom;
  TextStyle get labelMedium => typography.labelMedium;
  String get labelSmallFamily => typography.labelSmallFamily;
  bool get labelSmallIsCustom => typography.labelSmallIsCustom;
  TextStyle get labelSmall => typography.labelSmall;
  String get bodyLargeFamily => typography.bodyLargeFamily;
  bool get bodyLargeIsCustom => typography.bodyLargeIsCustom;
  TextStyle get bodyLarge => typography.bodyLarge;
  String get bodyMediumFamily => typography.bodyMediumFamily;
  bool get bodyMediumIsCustom => typography.bodyMediumIsCustom;
  TextStyle get bodyMedium => typography.bodyMedium;
  String get bodySmallFamily => typography.bodySmallFamily;
  bool get bodySmallIsCustom => typography.bodySmallIsCustom;
  TextStyle get bodySmall => typography.bodySmall;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends FlutterFlowTheme {
  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary = const Color(0xFF0D5C63);
  late Color secondary = const Color(0xFF0A2540);
  late Color tertiary = const Color(0xFFC9A84C);
  late Color alternate = const Color(0xFFE8E4DF);
  late Color primaryText = const Color(0xFF0A2540);
  late Color secondaryText = const Color(0xFF666666);
  late Color primaryBackground = const Color(0xFFFAF8F5);
  late Color secondaryBackground = const Color(0xFFFFFFFF);
  late Color accent1 = const Color(0x4C4B39EF);
  late Color accent2 = const Color(0x4D39D2C0);
  late Color accent3 = const Color(0xFFAEAEB2);
  late Color accent4 = const Color(0xCCFFFFFF);
  late Color success = const Color(0xFF6BAA8E);
  late Color warning = const Color(0xFFF9CF58);
  late Color error = const Color(0xFFE05C5C);
  late Color info = const Color(0xFFFFFFFF);

  late Color onPrimary = const Color(0xFFFFFFFF);
  late Color onSecondary = const Color(0xFFFFFFFF);
  late Color onSurface = const Color(0xFF0D5C63);
  late Color onError = const Color(0xFFFFFFFF);
  late Color transparent = const Color(0x00000000);
  late Color accent15 = const Color(0x26C9A84C);
  late Color accent40 = const Color(0x66C9A84C);
  late Color onSecondary70 = const Color(0xB3FFFFFF);
  late Color accent60 = const Color(0x99C9A84C);
  late Color accent30 = const Color(0x4DC9A84C);
  late Color onSecondary60 = const Color(0x99FFFFFF);
  late Color primary5 = const Color(0x0D0D5C63);
  late Color accent20 = const Color(0x33C9A84C);
  late Color surface70 = const Color(0xB3FFFFFF);
  late Color accent80 = const Color(0xCCC9A84C);
  late Color onPrimary10 = const Color(0x1AFFFFFF);
  late Color onPrimary20 = const Color(0x33FFFFFF);
  late Color success20 = const Color(0x336BAA8E);
  late Color onSurface80 = const Color(0xCC0D5C63);
  late Color onPrimary5 = const Color(0x0DFFFFFF);
  late Color onPrimary60 = const Color(0x99FFFFFF);
  late Color onPrimary30 = const Color(0x4DFFFFFF);
  late Color onPrimary40 = const Color(0x66FFFFFF);
  late Color onPrimary27 = const Color(0x45FFFFFF);
  late Color primary90 = const Color(0xE60D5C63);
  late Color secondaryText50 = const Color(0x80666666);
  late Color background97 = const Color(0xF7FAF8F5);
  late Color surface40 = const Color(0x66FFFFFF);
  late Color surface90 = const Color(0xE6FFFFFF);
  late Color surface80 = const Color(0xCCFFFFFF);
  late Color surface60 = const Color(0x99FFFFFF);
  late Color success15 = const Color(0x266BAA8E);
  late Color error15 = const Color(0x26E05C5C);
  late Color divider50 = const Color(0x80E8E4DF);
  late Color primary10 = const Color(0x1A0D5C63);
  late Color primary30 = const Color(0x4D0D5C63);
}

abstract class Typography {
  String get displayLargeFamily;
  bool get displayLargeIsCustom;
  TextStyle get displayLarge;
  String get displayMediumFamily;
  bool get displayMediumIsCustom;
  TextStyle get displayMedium;
  String get displaySmallFamily;
  bool get displaySmallIsCustom;
  TextStyle get displaySmall;
  String get headlineLargeFamily;
  bool get headlineLargeIsCustom;
  TextStyle get headlineLarge;
  String get headlineMediumFamily;
  bool get headlineMediumIsCustom;
  TextStyle get headlineMedium;
  String get headlineSmallFamily;
  bool get headlineSmallIsCustom;
  TextStyle get headlineSmall;
  String get titleLargeFamily;
  bool get titleLargeIsCustom;
  TextStyle get titleLarge;
  String get titleMediumFamily;
  bool get titleMediumIsCustom;
  TextStyle get titleMedium;
  String get titleSmallFamily;
  bool get titleSmallIsCustom;
  TextStyle get titleSmall;
  String get labelLargeFamily;
  bool get labelLargeIsCustom;
  TextStyle get labelLarge;
  String get labelMediumFamily;
  bool get labelMediumIsCustom;
  TextStyle get labelMedium;
  String get labelSmallFamily;
  bool get labelSmallIsCustom;
  TextStyle get labelSmall;
  String get bodyLargeFamily;
  bool get bodyLargeIsCustom;
  TextStyle get bodyLarge;
  String get bodyMediumFamily;
  bool get bodyMediumIsCustom;
  TextStyle get bodyMedium;
  String get bodySmallFamily;
  bool get bodySmallIsCustom;
  TextStyle get bodySmall;
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final FlutterFlowTheme theme;

  String get displayLargeFamily => 'Inter Tight';
  bool get displayLargeIsCustom => false;
  TextStyle get displayLarge => GoogleFonts.interTight(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 64.0,
      );
  String get displayMediumFamily => 'Inter Tight';
  bool get displayMediumIsCustom => false;
  TextStyle get displayMedium => GoogleFonts.interTight(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 44.0,
      );
  String get displaySmallFamily => 'Inter Tight';
  bool get displaySmallIsCustom => false;
  TextStyle get displaySmall => GoogleFonts.interTight(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 36.0,
      );
  String get headlineLargeFamily => 'Cormorant Garamond';
  bool get headlineLargeIsCustom => false;
  TextStyle get headlineLarge => GoogleFonts.cormorantGaramond(
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 34.0,
        height: 1.2,
      );
  String get headlineMediumFamily => 'Cormorant Garamond';
  bool get headlineMediumIsCustom => false;
  TextStyle get headlineMedium => GoogleFonts.cormorantGaramond(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 28.0,
        height: 1.25,
      );
  String get headlineSmallFamily => 'Inter Tight';
  bool get headlineSmallIsCustom => false;
  TextStyle get headlineSmall => GoogleFonts.interTight(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 24.0,
      );
  String get titleLargeFamily => 'Cormorant Garamond';
  bool get titleLargeIsCustom => false;
  TextStyle get titleLarge => GoogleFonts.cormorantGaramond(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 22.0,
        height: 1.27,
      );
  String get titleMediumFamily => 'Cormorant Garamond';
  bool get titleMediumIsCustom => false;
  TextStyle get titleMedium => GoogleFonts.cormorantGaramond(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 17.0,
        height: 1.35,
      );
  String get titleSmallFamily => 'Inter Tight';
  bool get titleSmallIsCustom => false;
  TextStyle get titleSmall => GoogleFonts.interTight(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
      );
  String get labelLargeFamily => 'DM Sans';
  bool get labelLargeIsCustom => false;
  TextStyle get labelLarge => GoogleFonts.dmSans(
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 15.0,
        height: 1.33,
      );
  String get labelMediumFamily => 'DM Sans';
  bool get labelMediumIsCustom => false;
  TextStyle get labelMedium => GoogleFonts.dmSans(
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 13.0,
        height: 1.38,
      );
  String get labelSmallFamily => 'DM Sans';
  bool get labelSmallIsCustom => false;
  TextStyle get labelSmall => GoogleFonts.dmSans(
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 11.0,
        height: 1.27,
      );
  String get bodyLargeFamily => 'DM Sans';
  bool get bodyLargeIsCustom => false;
  TextStyle get bodyLarge => GoogleFonts.dmSans(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 17.0,
        height: 1.5,
      );
  String get bodyMediumFamily => 'DM Sans';
  bool get bodyMediumIsCustom => false;
  TextStyle get bodyMedium => GoogleFonts.dmSans(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 15.0,
        height: 1.47,
      );
  String get bodySmallFamily => 'DM Sans';
  bool get bodySmallIsCustom => false;
  TextStyle get bodySmall => GoogleFonts.dmSans(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 13.0,
        height: 1.38,
      );
}

class DarkModeTheme extends FlutterFlowTheme {
  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary = const Color(0xFFC9A84C);
  late Color secondary = const Color(0xFF0D5C63);
  late Color tertiary = const Color(0xFFC9A84C);
  late Color alternate = const Color(0xFF1C2D41);
  late Color primaryText = const Color(0xFFFAF8F5);
  late Color secondaryText = const Color(0xFFA1A1A6);
  late Color primaryBackground = const Color(0xFF0A1628);
  late Color secondaryBackground = const Color(0xFF142132);
  late Color accent1 = const Color(0x4C4B39EF);
  late Color accent2 = const Color(0x4D39D2C0);
  late Color accent3 = const Color(0xFF636366);
  late Color accent4 = const Color(0xB2262D34);
  late Color success = const Color(0xFF6BAA8E);
  late Color warning = const Color(0xFFF9CF58);
  late Color error = const Color(0xFFE05C5C);
  late Color info = const Color(0xFFFFFFFF);

  late Color onPrimary = const Color(0xFF0A1628);
  late Color onSecondary = const Color(0xFFFFFFFF);
  late Color onSurface = const Color(0xFFFAF8F5);
  late Color onError = const Color(0xFFFFFFFF);
  late Color transparent = const Color(0x00000000);
  late Color accent15 = const Color(0x26C9A84C);
  late Color accent40 = const Color(0x66C9A84C);
  late Color onSecondary70 = const Color(0xB3FFFFFF);
  late Color accent60 = const Color(0x99C9A84C);
  late Color accent30 = const Color(0x4DC9A84C);
  late Color onSecondary60 = const Color(0x99FFFFFF);
  late Color primary5 = const Color(0x0DC9A84C);
  late Color accent20 = const Color(0x33C9A84C);
  late Color surface70 = const Color(0xB3142132);
  late Color accent80 = const Color(0xCCC9A84C);
  late Color onPrimary10 = const Color(0x1A0A1628);
  late Color onPrimary20 = const Color(0x330A1628);
  late Color success20 = const Color(0x336BAA8E);
  late Color onSurface80 = const Color(0xCCFAF8F5);
  late Color onPrimary5 = const Color(0x0D0A1628);
  late Color onPrimary60 = const Color(0x990A1628);
  late Color onPrimary30 = const Color(0x4D0A1628);
  late Color onPrimary40 = const Color(0x660A1628);
  late Color onPrimary27 = const Color(0x450A1628);
  late Color primary90 = const Color(0xE6C9A84C);
  late Color secondaryText50 = const Color(0x80A1A1A6);
  late Color background97 = const Color(0xF70A1628);
  late Color surface40 = const Color(0x66142132);
  late Color surface90 = const Color(0xE6142132);
  late Color surface80 = const Color(0xCC142132);
  late Color surface60 = const Color(0x99142132);
  late Color success15 = const Color(0x266BAA8E);
  late Color error15 = const Color(0x26E05C5C);
  late Color divider50 = const Color(0x801C2D41);
  late Color primary10 = const Color(0x1AC9A84C);
  late Color primary30 = const Color(0x4DC9A84C);
}

class FFDesignTokens {
  const FFDesignTokens(this.theme);
  final FlutterFlowTheme theme;
  FFSpacing get spacing => const FFSpacing();
  FFRadius get radius => const FFRadius();
  FFShadows get shadow => FFShadows(theme);
}

class FFSpacing {
  const FFSpacing();
  double get none => 0.0;
  double get xs => 4.0;
  double get sm => 8.0;
  double get md => 16.0;
  double get lg => 24.0;
  double get xl => 32.0;
  double get xxl => 48.0;
  double get xxxl => 64.0;
}

class FFRadius {
  const FFRadius();
  double get none => 0.0;
  double get xs => 2.0;
  double get sm => 8.0;
  double get md => 16.0;
  double get lg => 20.0;
  double get xl => 24.0;
  double get xxl => 32.0;
  double get full => 50.0;
}

class FFShadows {
  const FFShadows(this.theme);
  final FlutterFlowTheme theme;
  BoxShadow get sm => const BoxShadow(
      blurRadius: 24.0,
      color: Color(0x0F000000),
      offset: Offset(0.0, 4.0),
      spreadRadius: 0.0);
  BoxShadow get md => const BoxShadow(
      blurRadius: 32.0,
      color: Color(0x14000000),
      offset: Offset(0.0, 8.0),
      spreadRadius: 0.0);
  BoxShadow get lg => const BoxShadow(
      blurRadius: 40.0,
      color: Color(0x1A000000),
      offset: Offset(0.0, 12.0),
      spreadRadius: 0.0);
  BoxShadow get xl => const BoxShadow(
      blurRadius: 48.0,
      color: Color(0x26000000),
      offset: Offset(0.0, 16.0),
      spreadRadius: 0.0);
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    TextStyle? font,
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = false,
    TextDecoration? decoration,
    double? lineHeight,
    List<Shadow>? shadows,
    String? package,
  }) {
    if (useGoogleFonts && fontFamily != null) {
      font = GoogleFonts.getFont(fontFamily,
          fontWeight: fontWeight ?? this.fontWeight,
          fontStyle: fontStyle ?? this.fontStyle);
    }

    return font != null
        ? font.copyWith(
            color: color ?? this.color,
            fontSize: fontSize ?? this.fontSize,
            letterSpacing: letterSpacing ?? this.letterSpacing,
            fontWeight: fontWeight ?? this.fontWeight,
            fontStyle: fontStyle ?? this.fontStyle,
            decoration: decoration,
            height: lineHeight,
            shadows: shadows,
          )
        : copyWith(
            fontFamily: fontFamily,
            package: package,
            color: color,
            fontSize: fontSize,
            letterSpacing: letterSpacing,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            decoration: decoration,
            height: lineHeight,
            shadows: shadows,
          );
  }
}
