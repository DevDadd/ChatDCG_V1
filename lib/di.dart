import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'data/authen_service.dart';
import 'data/repository/authen_repository_impl.dart';
import 'domain/repository/authen_repository.dart';
import 'presentation/cubit/authen_cubit.dart';

final getIt = GetIt.instance;

// The Android emulator reaches the host machine through 10.0.2.2.
// For a real phone, use the computer's LAN IP and add it to the
// backend's DJANGO_ALLOWED_HOSTS.
String get _apiBaseUrl {
  final host = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? '10.0.2.2'
      : '127.0.0.1';
  return 'http://$host:8000';
}

void setupDI() {
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: _apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: Headers.jsonContentType,
      ),
    )..interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      ),
  );

  getIt.registerLazySingleton<AuthenService>(
    () => AuthenService(getIt<Dio>()),
  );

  getIt.registerLazySingleton<AuthenRepository>(
    () => AuthenRepositoryImpl(getIt<AuthenService>()),
  );

  // Factory: BlocProvider owns and closes each instance
  getIt.registerFactory<AuthenCubit>(
    () => AuthenCubit(getIt<AuthenRepository>()),
  );
}
