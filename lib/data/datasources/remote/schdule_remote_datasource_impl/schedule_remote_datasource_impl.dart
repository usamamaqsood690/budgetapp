import 'package:dio/dio.dart';
import 'package:wealthnxai/core/api_client/api_client.dart';
import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/errors/exception.dart';
import 'package:wealthnxai/data/datasources/base_remote_datasource.dart';
import 'package:wealthnxai/data/models/message_response_model/message_response_model.dart';
import 'package:wealthnxai/data/models/schedule/get_monthly_calender_response_model.dart/get_monthly_calender_response_model.dart';
import 'package:wealthnxai/data/models/schedule/get_schedule_model/get_schedule_response_model.dart';
import 'package:wealthnxai/data/models/schedule/get_upcoming_schedule_model/get_upcoming_schedule_model.dart';
import 'package:wealthnxai/domain/datasources/remote/schedule_remote_datasource/schedule_remote_datasource.dart';

/// ScheduleRemoteDataSource implementation - talks to HTTP APIs
class ScheduleRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ScheduleRemoteDataSource {
  final ApiClient apiClient;

  ScheduleRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UpcomingRecurringResponse> getUpcomingSchedule() async {
    try {
      final response = await apiClient.get(
        ApiConstants.getUpcomingSchedule,
        includeUserId: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message:
                'Invalid response format: expected Map but got ${response.data.runtimeType}',
            statusCode: response.statusCode,
          );
        }

        final scheduleResponse = UpcomingRecurringResponse.fromJson(
          response.data as Map<String, dynamic>,
        );

        if (!scheduleResponse.status) {
          throw ServerException(
            message: scheduleResponse.message,
            statusCode: response.statusCode,
          );
        }

        return scheduleResponse;
      } else {
        throw ServerException(
          message:
              response.data is Map
                  ? (response.data['message']?.toString() ??
                      'Failed to fetch upcoming schedule')
                  : 'Failed to fetch upcoming schedule',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'Failed to fetch upcoming schedule',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  @override
  Future<GetScheduleResponse> getScheduleByDateTime(String dateTime) async {
    try {
      final response = await apiClient.get(
        "${ApiConstants.getSchedules}?date=$dateTime",
        includeUserId: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message:
                'Invalid response format: expected Map but got ${response.data.runtimeType}',
            statusCode: response.statusCode,
          );
        }

        final scheduleResponse = GetScheduleResponse.fromJson(
          response.data as Map<String, dynamic>,
        );

        if (!scheduleResponse.status) {
          throw ServerException(
            message: scheduleResponse.message,
            statusCode: response.statusCode,
          );
        }

        return scheduleResponse;
      } else {
        throw ServerException(
          message:
              response.data is Map
                  ? (response.data['message']?.toString() ??
                      'Failed to fetch schedule')
                  : 'Failed to fetch schedule',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'Failed to fetch schedule',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  @override
  Future<MonthlyRecurringExpensesBody> getMonthlyCalenderData(
    int month,
    int year,
  ) async {
    try {
      final response = await apiClient.get(
        "${ApiConstants.getSchedules}?month=$month?year=$year",
        includeUserId: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw ServerException(
            message:
                'Invalid response format: expected Map but got ${response.data.runtimeType}',
            statusCode: response.statusCode,
          );
        }

        final monthlyCalenderDataResponse = MonthlyCalenderResponse.fromJson(
          response.data as Map<String, dynamic>,
        );

        if (!monthlyCalenderDataResponse.status) {
          throw ServerException(
            message: monthlyCalenderDataResponse.message,
            statusCode: response.statusCode,
          );
        }

        return monthlyCalenderDataResponse.body;
      } else {
        throw ServerException(
          message:
              response.data is Map
                  ? (response.data['message']?.toString() ??
                      'Failed to fetch calender data')
                  : 'Failed to fetch calender data',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw mapDioException(
        e,
        defaultServerMessage: 'Failed to fetch calender data',
      );
    } catch (e) {
      rethrowOrWrap(e);
    }
  }

  @override
  Future<MessageResponse> deleteSchedule({required String id}) async {
    return apiMessageResponse(
      apiCrudType: ApiCRUDType.delete,
      endpoint: "${ApiConstants.deleteSchedule}/$id?permanent=true",
      includeUserId: true,
      data: {},
      defaultFailureMessage: 'Failed to delete schedule',
      apiClient: apiClient,
    );
  }

  @override
  Future<MessageResponse> addSchedule({required Map<String, dynamic> body}) {
    return apiMessageResponse(
      apiCrudType: ApiCRUDType.post,
      endpoint: ApiConstants.addSchedule,
      includeUserId: true,
      data: body,
      defaultFailureMessage: 'Failed to create schedule',
      apiClient: apiClient,
    );
  }

  @override
  Future<MessageResponse> editSchedule({
    required String id,
    required Map<String, dynamic> body,
  }) {
    return apiMessageResponse(
      apiCrudType: ApiCRUDType.put,
      endpoint: "${ApiConstants.updateSchedule}/$id",
      includeUserId: true,
      data: body,
      defaultFailureMessage: 'Failed to update schedule',
      apiClient: apiClient,
    );
  }
}
