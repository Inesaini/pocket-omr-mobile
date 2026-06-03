import 'package:dio/dio.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/token_manager.dart';
import '../models/user_model.dart';

class AuthService {
  final TokenManager _tokenManager;
  final DioClient _dioClient;

  AuthService({TokenManager? tokenManager, DioClient? dioClient})
      : _tokenManager = tokenManager ?? TokenManager(),
        _dioClient = dioClient ?? DioClient();

  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.register,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
        },
        options: Options(extra: {'skipAuth': true}),
      );
      final data = response.data as Map<String, dynamic>;
      await _tokenManager.saveTokens(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
      );
      return UserModel.fromJson(data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(extra: {'skipAuth': true}),
      );
      final data = response.data as Map<String, dynamic>;
      await _tokenManager.saveTokens(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
      );
      return UserModel.fromJson(data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  Future<UserModel> getProfile() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.profile);
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  Future<void> logout() async {
    final refreshToken = await _tokenManager.getRefreshToken();
    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _dioClient.dio.post(
          ApiConstants.logout,
          data: {'refresh_token': refreshToken},
        );
      }
    } catch (_) {
      // Logout best-effort; clear tokens regardless
    }
    await _tokenManager.clearTokens();
  }

  Future<bool> hasStoredToken() async {
    final token = await _tokenManager.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Extract a readable error message from a DioException.
  String _extractError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      // FastAPI returns {"detail": "message"} or {"detail": [{"msg": "..."}]}
      final detail = data['detail'];
      if (detail is String) return detail;
      if (detail is List && detail.isNotEmpty) {
        final first = detail[0];
        if (first is Map<String, dynamic>) return first['msg'] ?? 'Request failed';
      }
    }
    if (e.response?.statusCode == 401) return 'Invalid email or password';
    if (e.response?.statusCode == 400) return 'Bad request';
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return 'Cannot connect to server';
    }
    return e.message ?? 'Something went wrong';
  }
}
