import 'package:chatdcg_demo/data/gRPC/gRPC_client.dart';
import 'package:chatdcg_demo/data/repository/authen_repository_impl.dart';
import 'package:chatdcg_demo/domain/repository/authen_repository.dart';
import 'package:chatdcg_demo/presentation/cubit/authen_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

const _grpcHost = String.fromEnvironment(
  'GRPC_HOST',
  defaultValue: 'altaria.proxy.rlwy.net',
);

const _grpcPort = int.fromEnvironment('GRPC_PORT', defaultValue: 59297);

void setupDI() {
  getIt.registerLazySingleton<GrpcClient>(
    () => GrpcClient(host: _grpcHost, port: _grpcPort),
  );

  getIt.registerLazySingleton<AuthenRepository>(() => AuthenRepositoryImpl());

  // Factory: BlocProvider owns and closes each instance
  getIt.registerFactory<AuthenCubit>(() => AuthenCubit());
}
