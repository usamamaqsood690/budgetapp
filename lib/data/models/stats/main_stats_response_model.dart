class StatsResponse {
  final bool status;
  final String message;
  final StatsBody body;

  StatsResponse({
    required this.status,
    required this.message,
    required this.body,
  });

  factory StatsResponse.fromJson(Map<String, dynamic> json) {
    return StatsResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      body: StatsBody.fromJson(json['body'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'body': body.toJson(),
  };
}
class StatsBody {
  final NetWorth networth;
  final Budget budget;
  final Cashflow cashflow;
  final List<TransactionItem> transactions;

  StatsBody({
    required this.networth,
    required this.budget,
    required this.cashflow,
    required this.transactions,
  });

  factory StatsBody.fromJson(Map<String, dynamic> json) {
    return StatsBody(
      networth: NetWorth.fromJson(json['networth'] ?? {}),
      budget: Budget.fromJson(json['budget'] ?? {}),
      cashflow: Cashflow.fromJson(json['cashflow'] ?? {}),
      transactions: (json['transactions'] as List? ?? [])
          .map((e) => TransactionItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'networth': networth.toJson(),
    'budget': budget.toJson(),
    'cashflow': cashflow.toJson(),
    'transactions': transactions.map((e) => e.toJson()).toList(),
  };
}

class NetWorth {
  final double totalNetWorth;
  final double cash;
  final double credit;
  final List<dynamic> cashAccounts;
  final List<dynamic> creditAccounts;

  NetWorth({
    required this.totalNetWorth,
    required this.cash,
    required this.credit,
    required this.cashAccounts,
    required this.creditAccounts,
  });

  factory NetWorth.fromJson(Map<String, dynamic> json) {
    return NetWorth(
      totalNetWorth: (json['totalNetWorth'] ?? 0).toDouble(),
      cash: (json['cash'] ?? 0).toDouble(),
      credit: (json['credit'] ?? 0).toDouble(),
      cashAccounts: json['cashAccounts'] ?? [],
      creditAccounts: json['creditAccounts'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'totalNetWorth': totalNetWorth,
    'cash': cash,
    'credit': credit,
    'cashAccounts': cashAccounts,
    'creditAccounts': creditAccounts,
  };
}

class Budget {
  final double totalBudget;
  final double remainingBudget;

  Budget({
    required this.totalBudget,
    required this.remainingBudget,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      totalBudget: (json['totalBudget'] ?? 0).toDouble(),
      remainingBudget: (json['remainingBudget'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'totalBudget': totalBudget,
    'remainingBudget': remainingBudget,
  };
}

class Cashflow {
  final double cashflow;
  final double cashflowPercentChange;

  Cashflow({
    required this.cashflow,
    required this.cashflowPercentChange,
  });

  factory Cashflow.fromJson(Map<String, dynamic> json) {
    return Cashflow(
      cashflow: (json['cashflow'] ?? 0).toDouble(),
      cashflowPercentChange:
      (json['cashflowPercentChange'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'cashflow': cashflow,
    'cashflowPercentChange': cashflowPercentChange,
  };
}
class TransactionItem {
  final String date;
  final double amount;
  final String title;
  final String logoUrl;

  TransactionItem({
    required this.date,
    required this.amount,
    required this.title,
    required this.logoUrl,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      date: json['date'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      title: json['title'] ?? '',
      logoUrl: json['logo_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'amount': amount,
    'title': title,
    'logo_url': logoUrl,
  };
}