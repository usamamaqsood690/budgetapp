import 'package:get/get.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/services/auth_service.dart';
import 'package:wealthnxai/data/datasources/remote/drawer_remote_datasource/profile_remote_datasource_impl/profile_remote_datasource_impl.dart';
import 'package:wealthnxai/data/network/network_info_impl.dart';
import 'package:wealthnxai/data/repositories/drawer_repository_impl/profile_repository_impl/profile_repository_impl.dart';
import 'package:wealthnxai/domain/datasources/remote/drawer_remote_datasource/profile_remote_datasource/profile_remote_datasource.dart';
import 'package:wealthnxai/domain/repositories/drawer_repository/profile_repository/profile_repository.dart';
import 'package:wealthnxai/domain/usecases/drawer/get_user_profile_usecase.dart';
import 'package:wealthnxai/domain/usecases/drawer/update_user_profile_usecase.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/profile/controller/user_profile_controller.dart';

class UserProfileBinding extends Bindings {
  @override
  void dependencies() {
    // 1. DataSource
    Get.lazyPut<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
    );

    // 2. Repository
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(
        remoteDataSource: Get.find<ProfileRemoteDataSource>(),
        networkInfo: NetworkInfoImpl.instance,
      ),
    );

    // 3. UseCases
    Get.lazyPut<GetUserProfileUseCase>(
      () => GetUserProfileUseCase(repository: Get.find<ProfileRepository>()),
    );

    Get.lazyPut<UpdateUserProfileUseCase>(
      () => UpdateUserProfileUseCase(repository: Get.find<ProfileRepository>()),
    );

    // 4. Controller
    Get.lazyPut<UserProfileController>(
      () => UserProfileController(
        getUserProfileUseCase: Get.find<GetUserProfileUseCase>(),
        updateUserProfileUseCase: Get.find<UpdateUserProfileUseCase>(),
        authService: AuthService.instance,
      ),
    );
  }
}
