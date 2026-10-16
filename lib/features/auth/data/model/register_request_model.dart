class RegisterRequestModel {
  final String name;
  final String fatherName;
  final String cnic;
  final String contactNumber;
  final String address;
  final String role;
  final String dob;
  final String password;
  final String otpCode;
  final String fcmToken;
  final String androidId;

  const RegisterRequestModel({
    required this.name,
    required this.fatherName,
    required this.cnic,
    required this.contactNumber,
    required this.address,
    required this.role,
    required this.dob,
    required this.password,
    required this.fcmToken,
    required this.androidId,
    required this.otpCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'fatherName': fatherName,
      'cnic': cnic,
      'contactNumber': contactNumber,
      'address': address,
      'role': role,
      'dob': dob,
      'password': password,
      'otpCode': otpCode,
      'fcmToken': fcmToken,
      'androidId': androidId,
    };
  }
}
