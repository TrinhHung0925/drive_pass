import 'package:flutter/material.dart';
import 'package:get/get.dart';
class AppColors {
  // Primary
  static const Color primary = Color(0xFF1F89E5); // Figma Hex: 1F89E5
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color secondary = Color(0xFF16A34A); // Mapped to success
  static const Color accent = Color(0xFFF59E0B); // Mapped to warning

  // Backgrounds
  static Color get background => Get.isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
  static Color get surface => Get.isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);

  // Text
  static Color get textPrimary => Get.isDarkMode ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
  static Color get textSecondary => Get.isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  static Color get textLight => Get.isDarkMode ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

  // Status Colors
  static const Color error = Color(0xFFDC2626); // Figma Hex: DC2626
  static Color get errorBackground => Get.isDarkMode ? const Color(0xFF450a0a) : const Color(0xFFFEE2E2);
  
  static const Color success = Color(0xFF16A34A); // Figma Hex: 16A34A
  static Color get successBackground => Get.isDarkMode ? const Color(0xFF052e16) : const Color(0xFFDCFCE7);
  
  static const Color warning = Color(0xFFF59E0B);
  
  // Borders
  static Color get border => Get.isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
}
