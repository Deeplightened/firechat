
import 'package:firechat/api/firebase/auth_api.dart';
import 'package:firechat/api/firebase/user_storage.dart';
import 'package:firechat/api/firebase/user_store.dart';
import 'package:firechat/domain/repositories/auth_repository.dart';
import 'package:firechat/domain/repositories/firebase/firebase_auth_repository.dart';
import 'package:firechat/domain/repositories/firebase/firebase_user_repository.dart';
import 'package:firechat/domain/repositories/user_repository.dart';
import 'package:get_it/get_it.dart';


final sl = GetIt.instance;

// Register dependency injection
Future<void> initDI() async {

  // API services
  sl.registerLazySingleton<FirebaseAuthApi>(() => FirebaseAuthApi());

  // Storage
  sl.registerLazySingleton<FirebaseUserStore>(() => FirebaseUserStore());
  sl.registerLazySingleton<FirebaseUserStorage>(() => FirebaseUserStorage());

  //  Repository
  sl.registerLazySingleton<UserRepository>(() => FirebaseUserRepository(sl(), sl(), sl()));
  sl.registerLazySingleton<AuthRepository>(() => FirebaseAuthRepository(sl(), sl()));
}