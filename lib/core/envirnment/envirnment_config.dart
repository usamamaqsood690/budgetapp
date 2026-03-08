import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';

class EnvironmentConfig {
  // Default environment is production
  static Environment _currentEnvironment = Environment.staging;
  /// Get current environment
  static Environment get current => _currentEnvironment;

  /// Set current environment (no persistence - in-memory only)
  static void setEnvironment(Environment environment) {
    _currentEnvironment = environment;
  }

  /// Initialize environment from string
  static Environment fromString(String? value) {
    if (value == null) return Environment.production;
    switch (value.toLowerCase()) {
      case 'prod':
      case 'production':
        return Environment.production;
      case 'stage':
      case 'staging':
        return Environment.staging;
      case 'dev':
        return Environment.dev;
      default:
        return Environment.production;
    }
  }

  static String getEnvironmentDisplayName(Environment env) {
    switch (env) {
      case Environment.dev:
        return 'dev';
      case Environment.staging:
        return 'stage';
      case Environment.production:
        return 'prod';
    }
  }

  /// Get base URL based on current environment
  static String getBaseUrl() {
    switch (_currentEnvironment) {
      case Environment.production:
        return ApiConstants.productionBaseUrl;
      case Environment.staging:
        return ApiConstants.stagingBaseUrl;
      case Environment.dev:
        return ApiConstants.devBaseUrl;
    }
  }
}
