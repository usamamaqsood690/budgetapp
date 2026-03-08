class MessageResponse {
  bool? status;
  String? message;
  MessageResponse({this.status, this.message,});

  // Factory constructor to create an instance from JSON
  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      status: json['status'],
      message: json['message'],
    );
  }

  // Method to convert instance back to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}