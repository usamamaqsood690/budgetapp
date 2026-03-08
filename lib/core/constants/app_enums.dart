/// App Environment
enum Environment { dev, staging, production }

/// OTP Verification Type
enum OtpVerificationType { signup, forgotPassword, recoverEmail, other }

/// Social password setup screen.
enum SocialPlatformAuthProvider { google, apple }

/// PASSWORD CHANGE TYPE
enum PasswordChangeType { newPassword, changePassword }

/// ACCOUNT TYPE
enum AccountType { recover, delete }

///CRUD Type
enum ApiCRUDType {get, post, put, delete}

///Stock Type
enum StockTab { all, trending, gainers, losers }

///Stock Chart Mode
enum ChartMode { line, candle }

/// SCHEDULE ACTION
enum ScheduleFormType { create, edit }

/// Supported recurrence intervals for a schedule.
enum RecurrenceIntervalType { daily, weekly, monthly, yearly }

/// crypto tab
enum CryptoTab { trending, gainers, losers, newCoins, all }

/// schedule type
enum ScheduleType {plaid , manual}

/// CashFlow tab
enum CashFlowTab { overview, income, expense }

/// NetWorth tab
enum NetWorthTab { overview, assets, liabilities }

/// Chart Graph Range
enum ChartGraphRange { oneMonth, threeMonths, sixMonths, oneYear, ytd }

///pokemon API Type
enum PokemonApiSource { cashFlow, netWorth, budget }

