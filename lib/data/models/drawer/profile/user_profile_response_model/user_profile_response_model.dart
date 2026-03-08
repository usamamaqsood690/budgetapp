class ProfileResponse {
  final bool status;
  final String message;
  final ProfileBody body;

  ProfileResponse({
    required this.status,
    required this.message,
    required this.body,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      body: ProfileBody.fromJson(json['body']),
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

class ProfileBody {
  final String id;
  final String fullName;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNo;
  final String dob;
  final String address;
  final String gender;
  final String maritalState;
  final String profilePic;
  final String socialLink;

  ProfileBody({
    required this.id,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNo,
    required this.dob,
    required this.address,
    required this.gender,
    required this.maritalState,
    required this.profilePic,
    required this.socialLink,
  });

  factory ProfileBody.fromJson(Map<String, dynamic> json) {
    return ProfileBody(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      dob: json['dob'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      maritalState: json['maritalState'] ?? '',
      profilePic: json['profilePic'] ?? '',
      socialLink: json['socialLink'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNo': phoneNo,
      'dob': dob,
      'address': address,
      'gender': gender,
      'maritalState': maritalState,
      'profilePic': profilePic,
      'socialLink': socialLink,
    };
  }
}