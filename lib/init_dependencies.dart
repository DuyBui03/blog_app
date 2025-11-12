import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecase/current_user.dart';
import 'package:blog_app/features/auth/domain/usecase/user_login.dart';
import 'package:blog_app/features/auth/domain/usecase/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/datasource/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/datasource/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog_app/features/blog/domain/usecase/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecase/upload_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  serviceLocator.registerLazySingleton<SupabaseClient>(() => supabase.client);
  serviceLocator.registerFactory(() => InternetConnection());
  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));
  serviceLocator.registerLazySingleton<AppUserCubit>(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory<UserSignUp>(() => UserSignUp(serviceLocator()))
    ..registerFactory<UserLogin>(() => UserLogin(serviceLocator()))
    ..registerFactory<CurrentUser>(() => CurrentUser(serviceLocator()))
    ..registerFactory<AuthBloc>(
      () => AuthBloc(
        userSignUp: serviceLocator<UserSignUp>(),
        userLogin: serviceLocator<UserLogin>(),
        currentUser: serviceLocator<CurrentUser>(),
        appUserCubit: serviceLocator<AppUserCubit>(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogLocalDataSource>(() => BlogLocalDataSourceImpl(serviceLocator()))
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory<UploadBlog>(() => UploadBlog(serviceLocator()))
    ..registerFactory<GetAllBlogs>(() => GetAllBlogs(serviceLocator()))
    ..registerFactory(
      () =>
          BlogBloc(uploadBlog: serviceLocator(), getAllBlogs: serviceLocator()),
    );
}
