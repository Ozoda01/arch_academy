import 'package:dio/dio.dart';
import '../error/failure.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({required Dio dio}) : _dio = dio {
    // Default URL that can be overridden or updated when live mock is configured.
    _dio.options.baseUrl = "https://raw.githubusercontent.com/otabek-dev/arch_academy_mock/main/"; // Github pages or raw CDN fallback
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure("Serverga ulanishda kutish vaqti tugadi");
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        return ServerFailure("Server xatoligi: $statusCode");
      case DioExceptionType.cancel:
        return const NetworkFailure("So'rov bekor qilindi");
      case DioExceptionType.connectionError:
        return const NetworkFailure("Internetga ulanish xatoligi");
      default:
        return const ServerFailure("Kutilmagan xatolik yuz berdi");
    }
  }
}
