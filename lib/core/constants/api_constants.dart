/// API Constants - All API endpoints and configuration
class ApiConstants {
  static const String productionBaseUrl =
      'https://wealthnxapi-gra7hxd5decbd0d0.centralus-01.azurewebsites.net/api/users';
  static const String stagingBaseUrl = 'http://10.0.1.10:5000/api/users';
  static const String devBaseUrl = 'http://10.0.1.10:3000/api/users';

  ///Discord Link
  static const String discordLink = 'https://discord.com/invite/FNs9TKVM';

  /// Auth Endpoints
  static const String login = '/signin';
  static const String register = '/signup';
  static const String logout = '/logout';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String sendOtpGmail = '/send-otp-gmail';
  static const String recoverAccountOtpGmail = '/profile/restore/request-otp';
  static const String verifyOtp = '/verify-otp';
  static const String googleAuth = '/google-auth';
  static const String changePassword = '/change-password';

  /// Profile Endpoints
  static const String userProfile = '/profile/get';
  static const String updateProfile = '/profile/update';
  static const String deleteAccount = '/profile/delete';

  /// Feedback Endpoints
  static const String feedback = '/feedback';

  /// Schedule Endpoints
  static const String getUpcomingSchedule = '/upcoming-recurring-expenses';
  static const String getSchedules = '/expenses/schedule';
  static const String addSchedule = '/expenses/recurring';
  static const String updateSchedule = '/schedules';
  static const String deleteSchedule = '/schedules';

  ///Plaid Connection Check
  static const String plaidConnectionCheck = '/plaid-connection';

  ///Stats Endpoints
  static const String getStats = '/stats';
  ///CashFlow Endpoints
  static const String incomeSummary = '/income-summary';
  static const String expenseSummary = '/expenses/summary-advanced';
  static const String cashFlowSummery = '/cashflow-summary';
  static const String cashFlowPokemonSummary = '/cashflow-sumary';
  static const String getAllCashFlow = '/cashflows';

  /// Transaction
  static const String getTransaction = '/plaid/transactions';
  ///NetWorth
  static const String netWorthSummery = '/networth/summary-advanced';
  static const String assetsSummery = '/assets/asset-summary';
  static const String liabilitiesSummery = '/liabilities/liabilities-summary';
  static const String netWorthPokemonSummary = '/networth/summary';
  static const String getAllNetWorth = '/networth';

  ///Budget
  static const String getBudget = '/budgets';


  // News Endpoints (Updated)
  static const String newsLatest =
      '/news/latest'; // ?type=general|crypto|stock&page=1&limit=10
  static const String newsBySymbol =
      '/news/symbol/'; // {symbol}?page=1&limit=20

  // Stock APIs
  static const String stockList = '/stocklist';
  static const String stockProfile = '/stockprofile';
  // ─── Financial Modeling Prep (FMP) ────────────────────────────────────────
  static const String fmpBaseUrl = 'https://financialmodelingprep.com';
  static const String fmpApiKey = 'uHqogK3lOZ3TDN6HbvvQc3vHUKLVkz3g';

  // ─── Crypto Endpoints ─────────────────────────────────────────────────────
  // GET /cryptolist?listType=All|Trending|Gainers|Losers|New&page=1&limit=10
  // GET /cryptolist?search=eth&page=1&limit=10
  // GET /cryptoprofile?sym=bitcoin
  static const String cryptoList = '/cryptolist';
  static const String cryptoProfile = '/cryptoprofile';
  // ─── CoinGecko (chart data only) ──────────────────────────────────────────
  static const String coinGeckoBaseUrl = 'https://pro-api.coingecko.com/api/v3'; // Usage: GET /coins/{id}/ohlc?vs_currency=usd&days=1
  static const String coinGeckoApiKey = 'CG-WA6uPbtYUPRqcRZNpcdw9AZ7';


  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Teams Webhook URL for error notifications
  static const String? teamsWebhookUrl =
      'https://default633082c50be44361bed3765b3dfe42.51.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/0e2178fc89004bfdb8d699259a8ef52c/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=NfHhNKppJ3G8y5XVapUQRtFjv06FNoP1-o5lHHet-2Q';

  // Private constructor to prevent instantiation
  ApiConstants._();
}

