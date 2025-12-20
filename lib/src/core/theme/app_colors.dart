import 'package:flutter/material.dart';

/// AppColors
/// Merged theme combining existing colors with new Sky Blue & White theme
/// for ELMS (E‑Learning Management System)
class AppColors {
  AppColors._(); // private constructor

  // ============================
  // Legacy/Existing Colors (Keep for backward compatibility)
  // ============================
  
  static const Color primaryColor = Color(0xff0E96C5);
  
  // Backgrounds (existing)
  static const Color scaffoldLightThemeBackground = Colors.white;
  static Color? scaffoldDarkThemeBackground = Colors.grey[900];
  static const Color bgColor = Color(0xFFF6F9FB);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color selectedCard = Color(0xFFDFF6FF);
  
  // Borders (existing)
  static const Color selectedBorder = Color(0xFF0E96C5);
  
  // Text (existing)
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  
  // Buttons (existing)
  static const Color buttonBackground = Color(0xFF0E96C5);
  static const Color buttonText = Color(0xFFFFFFFF);
  
  // Others (existing)
  static const Color searchFill = Color(0xFFF0F2F5);
  static const Color iconColor = Color(0xFF1A1A1A);
  static const Color appBarTitle = Color(0xFF1A1A1A);
  static const Color background = Color(0xFFE0E5EC);
  static const Color darkBackground = Color(0xFFC0C3C7);
  static const Color text = Colors.black87;
  static Color? containerColor = Colors.grey[100];

  // ============================
  // New Sky Blue Theme Colors
  // ============================
  
  /// Main sky blue color (Primary)
  static const Color primary = Color(0xFF4FC3F7); // Sky Blue
  
  /// Darker sky blue (for AppBar, buttons, accent bars)
  static const Color primaryDark = Color(0xFF0288D1);
  
  /// Light sky blue (backgrounds, cards)
  static const Color primaryLight = Color(0xFFE1F5FE);

  // ============================
  // Accent Colors
  // ============================
  
  /// Accent blue (highlights, active states, icons)
  static const Color accent = Color(0xFF29B6F6);
  
  /// Soft accent (icons, borders)
  static const Color accentLight = Color(0xFFB3E5FC);

  // ============================
  // New Background Colors
  // ============================
  
  /// Screen background (very light blue)
  static const Color screenBackground = Color(0xFFF5FBFF);
  
  /// Card background
  static const Color card = Color(0xFFFFFFFF);

  // ============================
  // New Text Colors
  // ============================
  
  /// Primary text color (titles)
  static const Color textPrimaryNew = Color(0xFF0D47A1);
  
  /// Secondary text (subtitles, descriptions)
  static const Color textSecondaryNew = Color(0xFF546E7A);
  
  /// Hint / disabled text
  static const Color textHint = Color(0xFF90A4AE);
  
  /// Text on primary color
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ============================
  // Button Colors (New)
  // ============================
  
  static const Color buttonPrimary = primary;
  static const Color buttonPrimaryText = textOnPrimary;
  static const Color buttonSecondary = primaryLight;
  static const Color buttonSecondaryText = primaryDark;

  // ============================
  // Border & Divider Colors
  // ============================
  
  static const Color border = Color(0xFFBEE7F8);
  static const Color divider = Color(0xFFE0E0E0);

  // ============================
  // Status Colors
  // ============================
  
  /// Success (completed lesson, passed quiz)
  static const Color success = Color(0xFF2ECC71);
  
  /// Warning (pending tasks)
  static const Color warning = Color(0xFFFBC02D);
  
  /// Error (failed login, validation)
  static const Color error = Color(0xFFE53935);
  
  /// Info (tips, messages)
  static const Color info = Color(0xFF29B6F6);

  // ============================
  // Shadows
  // ============================
  
  static const Color shadow = Color(0x1A000000);

  // ============================
  // Gradients
  // ============================
  
  /// Primary gradient (Sky Blue to Accent Blue)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primary,      // Sky Blue
      accent,       // Accent Blue
    ],
  );
  
  /// Soft gradient (White to Light Sky Blue)
  static const LinearGradient softGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      primaryLight,
    ],
  );
}