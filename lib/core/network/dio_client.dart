import 'package:dio/dio.dart';
import 'api_constants.dart';
import 'token_manager.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late final Dio _dio;
  final TokenManager _tokenManager = TokenManager();
  bool _isRefreshing = false;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.extra['skipAuth'] != true) {
            final token = await _tokenManager.getAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          final request = e.requestOptions;
          final isRefreshCall = request.path == ApiConstants.refresh;
          final alreadyRetried = request.extra['retried'] == true;

          if (e.response?.statusCode == 401 &&
              !isRefreshCall &&
              !alreadyRetried &&
              request.extra['skipAuth'] != true) {
            final refreshed = await _tryRefresh();
            if (refreshed) {
              final newToken = await _tokenManager.getAccessToken();
              request.headers['Authorization'] = 'Bearer $newToken';
              request.extra['retried'] = true;
              try {
                final response = await _dio.fetch(request);
                return handler.resolve(response);
              } on DioException catch (retryError) {
                return handler.next(retryError);
              }
            } else {
              await _tokenManager.clearTokens();
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<bool> _tryRefresh() async {
    if (_isRefreshing) return false;
    final refreshToken = await _tokenManager.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;

    _isRefreshing = true;
    try {
      final response = await _dio.post(
        ApiConstants.refresh,
        data: {'refresh_token': refreshToken},
        options: Options(extra: {'skipAuth': true}),
      );
      final data = response.data as Map<String, dynamic>;
      await _tokenManager.saveTokens(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
      );
      return true;
    } on DioException {
      return false;
    } finally {
      _isRefreshing = false;
    }
  }
}
