// Dependency injection + Singleton yapmak için
import 'package:get_it/get_it.dart';
import 'provider/smoke_provider.dart';
import 'repository/smoke_repository.dart';

GetIt locator = GetIt();
void setupLocator() {
  locator.registerLazySingleton(() => SmokeRepository());
  locator.registerFactory(() => SmokeProvider());
}
