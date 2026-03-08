class PlaidConnectionResponse {
  final bool status;
  final String message;
  final PlaidBody body;

  PlaidConnectionResponse({
    required this.status,
    required this.message,
    required this.body,
  });

  factory PlaidConnectionResponse.fromJson(Map<String, dynamic> json) {
    return PlaidConnectionResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      body: PlaidBody.fromJson(json['body'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'body': body.toJson(),
    };
  }
}

class PlaidBody {
  final bool isPlaidConnected;
  final bool isAccountant;
  final bool isInvestment;

  PlaidBody({
    required this.isPlaidConnected,
    required this.isAccountant,
    required this.isInvestment,
  });

  factory PlaidBody.fromJson(Map<String, dynamic> json) {
    return PlaidBody(
      isPlaidConnected: json['isPlaidConnected'] ?? false,
      isAccountant: json['isAccountant'] ?? false,
      isInvestment: json['isInvestment'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isPlaidConnected': isPlaidConnected,
      'isAccountant': isAccountant,
      'isInvestment': isInvestment,
    };
  }
}