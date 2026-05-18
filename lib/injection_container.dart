import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'core/network/api_client.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Core Services
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(dio: getIt<Dio>()));

  // Features registration will be added dynamically as we develop them.
}
