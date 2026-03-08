import 'package:wealthnxai/data/models/stats/main_stats_response_model.dart';

abstract class StatsRemoteDataSource {
  Future<StatsResponse> getStatsSummary();
}

