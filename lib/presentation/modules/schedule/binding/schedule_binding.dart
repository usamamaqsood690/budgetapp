import 'package:get/get.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/data/datasources/remote/schdule_remote_datasource_impl/schedule_remote_datasource_impl.dart';
import 'package:wealthnxai/data/repositories/schedule_repository_impl/schedule_repository_impl.dart';
import 'package:wealthnxai/domain/datasources/remote/schedule_remote_datasource/schedule_remote_datasource.dart';
import 'package:wealthnxai/domain/network/network_info.dart';
import 'package:wealthnxai/domain/repositories/schedule_repository/schedule_repository.dart';
import 'package:wealthnxai/domain/usecases/schedule/add_schedule_usecase.dart';
import 'package:wealthnxai/domain/usecases/schedule/delete_schedule_usecase.dart';
import 'package:wealthnxai/domain/usecases/schedule/edit_schedule_usecase.dart';
import 'package:wealthnxai/domain/usecases/schedule/get_monthly_calender_usecase.dart';
import 'package:wealthnxai/domain/usecases/schedule/get_schedule_usecase.dart';
import 'package:wealthnxai/domain/usecases/schedule/get_upcoming_schedule_usecase.dart';
import 'package:wealthnxai/presentation/modules/schedule/controller/schedule_controller.dart';
import 'package:wealthnxai/presentation/modules/schedule/page/add_schedule/controller/add_schedule_controller.dart';

/// Schedule Binding - Dependency Injection
class ScheduleBinding extends Bindings {
  @override
  void dependencies() {
    // Data Source
    Get.lazyPut<ScheduleRemoteDataSource>(
      () => ScheduleRemoteDataSourceImpl(apiClient: ApiClient.instance),
    );

    // Repository
    Get.lazyPut<ScheduleRepository>(
      () => ScheduleRepositoryImpl(
        remoteDataSource: Get.find<ScheduleRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );

    // Use Cases
    Get.lazyPut(
      () => GetUpcomingScheduleUseCase(
        repository: Get.find<ScheduleRepository>(),
      ),
    );
    Get.lazyPut(
      () => GetScheduleUseCase(repository: Get.find<ScheduleRepository>()),
    );
    Get.lazyPut(
      () =>
          GetMonthlyCalenderUseCase(repository: Get.find<ScheduleRepository>()),
    );
    Get.lazyPut(
      () => DeleteScheduleUseCase(repository: Get.find<ScheduleRepository>()),
    );
    // Controllers
    Get.lazyPut(
      () => ScheduleController(
        getUpcomingScheduleUseCase: Get.find<GetUpcomingScheduleUseCase>(),
        getScheduleUseCase: Get.find<GetScheduleUseCase>(),
        getMonthlyCalenderUseCase: Get.find<GetMonthlyCalenderUseCase>(),
        deleteScheduleUseCase: Get.find<DeleteScheduleUseCase>(),
      ),
    );
  }
}
