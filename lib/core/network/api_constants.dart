import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  /// Backend host, resolved in this order:
  ///   1. `--dart-define=API_HOST=<ip>` override (use the dev machine's LAN IP
  ///      for a PHYSICAL device, e.g. `--dart-define=API_HOST=192.168.1.6`,
  ///      and run the backend with `--host 0.0.0.0`);
  ///   2. Android emulator default `10.0.2.2` (maps to the host's localhost);
  ///   3. `localhost` for web / iOS simulator / desktop.
  static const String _hostOverride = String.fromEnvironment('API_HOST');

  static String get _host {
    if (_hostOverride.isNotEmpty) return _hostOverride;
    if (!kIsWeb && Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  /// Full base URL; override the whole thing with `--dart-define=API_BASE_URL`.
  static const String _baseUrlOverride = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl =>
      _baseUrlOverride.isNotEmpty ? _baseUrlOverride : 'http://$_host:8000/api/v1';

  // Health
  static const String health = '/health';

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String profile = '/auth/me';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Exams
  static const String exams = '/exams';
  static const String examsRecent = '/exams/recent';
  static const String examsToCorrect = '/exams/to-correct';
  static const String examsHistory = '/exams/history';
  static String examDetail(String id) => '/exams/$id';
  static String examMobile(String id) => '/exams/$id/mobile';
  static String examUploadImages(String id) => '/exams/$id/upload-images';
}
