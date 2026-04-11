import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AppConfig {
  static String _imgbbApiKey = '';
  static String _sslStoreId = '';
  static String _sslStorePassword = '';
  static bool _sslSandboxMode = true;
  static String _emailOtpAppName = 'Jihad Mart';
  static String _emailOtpAppEmail = '';
  static String _emailOtpSmtpHost = '';
  static String _emailOtpSmtpUsername = '';
  static String _emailOtpSmtpPassword = '';
  static int _emailOtpSmtpPort = 587;
  static String _emailOtpSmtpSecureType = 'tls';

  static String get imgbbApiKey => _imgbbApiKey;
  static String get sslStoreId => _sslStoreId;
  static String get sslStorePassword => _sslStorePassword;
  static bool get sslSandboxMode => _sslSandboxMode;
  static String get emailOtpAppName => _emailOtpAppName;
  static String get emailOtpAppEmail => _emailOtpAppEmail;
  static String get emailOtpSmtpHost => _emailOtpSmtpHost;
  static String get emailOtpSmtpUsername => _emailOtpSmtpUsername;
  static String get emailOtpSmtpPassword => _emailOtpSmtpPassword;
  static int get emailOtpSmtpPort => _emailOtpSmtpPort;
  static String get emailOtpSmtpSecureType => _emailOtpSmtpSecureType;

  static Future<void> load() async {
    _imgbbApiKey = const String.fromEnvironment('IMGBB_API_KEY', defaultValue: '').trim();
    _sslStoreId = const String.fromEnvironment('SSLCOMMERZ_STORE_ID', defaultValue: '').trim();
    _sslStorePassword =
        const String.fromEnvironment('SSLCOMMERZ_STORE_PASSWORD', defaultValue: '').trim();
    _emailOtpAppName =
      const String.fromEnvironment('EMAIL_OTP_APP_NAME', defaultValue: 'Jihad Mart').trim();
    _emailOtpAppEmail =
      const String.fromEnvironment('EMAIL_OTP_APP_EMAIL', defaultValue: '').trim();
    _emailOtpSmtpHost =
      const String.fromEnvironment('EMAIL_OTP_SMTP_HOST', defaultValue: '').trim();
    _emailOtpSmtpUsername =
      const String.fromEnvironment('EMAIL_OTP_SMTP_USERNAME', defaultValue: '').trim();
    _emailOtpSmtpPassword =
      const String.fromEnvironment('EMAIL_OTP_SMTP_PASSWORD', defaultValue: '').trim();
    _emailOtpSmtpPort = int.tryParse(
        const String.fromEnvironment('EMAIL_OTP_SMTP_PORT', defaultValue: '587').trim(),
      ) ??
      587;
    _emailOtpSmtpSecureType =
      const String.fromEnvironment('EMAIL_OTP_SMTP_SECURE_TYPE', defaultValue: 'tls').trim();

    final sandboxValue =
        const String.fromEnvironment('SSLCOMMERZ_IS_SANDBOX', defaultValue: 'true').trim();
    _sslSandboxMode = sandboxValue.toLowerCase() != 'false';

    if (_hasAllRequiredKeys()) {
      return;
    }

    // On mobile APK/IPA, read .env from bundled Flutter assets first.
    await _tryLoadFromAssetEnv();
    if (_hasAllRequiredKeys()) {
      return;
    }

    if (kIsWeb) {
      return;
    }

    // Fallback for local desktop/dev runs where .env is available in cwd.
    await _tryLoadFromFileEnv();
  }

  static bool _hasAllRequiredKeys() {
    return _imgbbApiKey.isNotEmpty && _sslStoreId.isNotEmpty && _sslStorePassword.isNotEmpty;
  }

  static Future<void> _tryLoadFromAssetEnv() async {
    try {
      final envContent = await rootBundle.loadString('.env');
      _applyEnvContent(envContent);
    } catch (_) {
      // Asset may not exist for local setups.
    }
  }

  static Future<void> _tryLoadFromFileEnv() async {
    try {
      final envFile = File('.env');
      if (!await envFile.exists()) {
        return;
      }

      final envContent = await envFile.readAsString();
      _applyEnvContent(envContent);
    } catch (_) {
      // Intentionally ignore file read errors and keep the key empty.
    }
  }

  static void _applyEnvContent(String envContent) {
    final lines = envContent.split(RegExp(r'\r?\n'));
    for (final rawLine in lines) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#') || !line.contains('=')) {
        continue;
      }

      final index = line.indexOf('=');
      final key = line.substring(0, index).trim();
      var value = line.substring(index + 1).trim();
      if (value.length >= 2 && value.startsWith('"') && value.endsWith('"')) {
        value = value.substring(1, value.length - 1).trim();
      }

      if (value.isEmpty || value.toLowerCase().contains('your_sandbox_')) {
        continue;
      }

      if (key == 'IMGBB_API_KEY') {
        _imgbbApiKey = value;
        continue;
      }

      if (key == 'SSLCOMMERZ_STORE_ID') {
        _sslStoreId = value;
        continue;
      }

      if (key == 'SSLCOMMERZ_STORE_PASSWORD') {
        _sslStorePassword = value;
        continue;
      }

      if (key == 'SSLCOMMERZ_IS_SANDBOX') {
        _sslSandboxMode = value.toLowerCase() != 'false';
        continue;
      }

      if (key == 'EMAIL_OTP_APP_NAME' && value.isNotEmpty) {
        _emailOtpAppName = value;
        continue;
      }

      if (key == 'EMAIL_OTP_APP_EMAIL' && value.isNotEmpty) {
        _emailOtpAppEmail = value;
        continue;
      }

      if (key == 'EMAIL_OTP_SMTP_HOST' && value.isNotEmpty) {
        _emailOtpSmtpHost = value;
        continue;
      }

      if (key == 'EMAIL_OTP_SMTP_USERNAME' && value.isNotEmpty) {
        _emailOtpSmtpUsername = value;
        continue;
      }

      if (key == 'EMAIL_OTP_SMTP_PASSWORD' && value.isNotEmpty) {
        _emailOtpSmtpPassword = value;
        continue;
      }

      if (key == 'EMAIL_OTP_SMTP_PORT') {
        final parsedPort = int.tryParse(value);
        if (parsedPort != null) {
          _emailOtpSmtpPort = parsedPort;
        }
        continue;
      }

      if (key == 'EMAIL_OTP_SMTP_SECURE_TYPE' && value.isNotEmpty) {
        _emailOtpSmtpSecureType = value.toLowerCase();
      }
    }
  }
}