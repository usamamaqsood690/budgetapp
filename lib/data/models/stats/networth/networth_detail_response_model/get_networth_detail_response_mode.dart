class NetWorthResponseModel {
  final bool status;
  final String message;
  final NetWorthBody body;

  NetWorthResponseModel({
    required this.status,
    required this.message,
    required this.body,
  });

  factory NetWorthResponseModel.fromJson(Map<String, dynamic> json) {
    return NetWorthResponseModel(
      status: json['status'],
      message: json['message'],
      body: NetWorthBody.fromJson(json['body']),
    );
  }
}

class NetWorthBody {
  final double totalNetWorth;
  final double totalAssets;
  final double totalLiabilities;
  final String totalAssetsPercentage;
  final String totalLiabilitiesPercentage;
  final String percentageNetWorth;

  final List<AssetModel> assets;
  final List<LiabilityModel> liabilities;

  NetWorthBody({
    required this.totalNetWorth,
    required this.totalAssets,
    required this.totalLiabilities,
    required this.totalAssetsPercentage,
    required this.totalLiabilitiesPercentage,
    required this.percentageNetWorth,
    required this.assets,
    required this.liabilities,
  });

  factory NetWorthBody.fromJson(Map<String, dynamic> json) {
    return NetWorthBody(
      totalNetWorth: (json['totalNetWorth'] ?? 0).toDouble(),
      totalAssets: (json['totalAssets'] ?? 0).toDouble(),
      totalLiabilities: (json['totalLiabilities'] ?? 0).toDouble(),
      totalAssetsPercentage: json['totalAssetsPercentage'] ?? '',
      totalLiabilitiesPercentage: json['totalLiabilitiesPercentage'] ?? '',
      percentageNetWorth: json['percentageNetWorth'] ?? '',
      assets: (json['assets'] as List)
          .map((e) => AssetModel.fromJson(e))
          .toList(),
      liabilities: (json['liabilities'] as List)
          .map((e) => LiabilityModel.fromJson(e))
          .toList(),
    );
  }
}

class AssetModel {
  final String accountId;
  final String name;
  final String type;
  final String subtype;
  final double currentBalance;
  final double availableBalance;
  final String percentage;
  final String bankName;
  final String accountNumber;
  final String bankLogo;

  AssetModel({
    required this.accountId,
    required this.name,
    required this.type,
    required this.subtype,
    required this.currentBalance,
    required this.availableBalance,
    required this.percentage,
    required this.bankName,
    required this.accountNumber,
    required this.bankLogo,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      accountId: json['accountId'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      subtype: json['subtype'] ?? '',
      currentBalance: (json['currentBalance'] ?? 0).toDouble(),
      availableBalance: (json['availableBalance'] ?? 0).toDouble(),
      percentage: json['percentage'] ?? '',
      bankName: json['bankName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      bankLogo: json['bankLogo'] ?? '',
    );
  }
}

class LiabilityModel {
  final String type;
  final String name;
  final double amount;
  final String percentage;
  final String accountId;
  final String bankName;
  final String bankLogo;
  final String accountNumber;
  final String subtype;

  LiabilityModel({
    required this.type,
    required this.name,
    required this.amount,
    required this.percentage,
    required this.accountId,
    required this.bankName,
    required this.bankLogo,
    required this.accountNumber,
    required this.subtype,
  });

  factory LiabilityModel.fromJson(Map<String, dynamic> json) {
    return LiabilityModel(
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      percentage: json['percentage'] ?? '',
      accountId: json['accountId'] ?? '',
      bankName: json['bankName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      subtype: json['subtype'] ?? '',
      bankLogo: json['bankLogo'] ?? '',
    );
  }
}