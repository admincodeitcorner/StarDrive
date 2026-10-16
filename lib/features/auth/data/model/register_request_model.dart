class RegisterRequestModel {
  final String name;
  final String contactNumber;
  final String role;
  final String password;
  final String otpCode;
  final String fcmToken;
  final String androidId;

  final String? fatherName;
  final String? cnic;
  final String? address;
  final String? dob;

  const RegisterRequestModel({
    required this.name,
    required this.contactNumber,
    required this.role,
    required this.password,
    required this.otpCode,
    required this.fcmToken,
    required this.androidId,
    this.fatherName,
    this.cnic,
    this.address,
    this.dob,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'contactNumber': contactNumber,
        'role': role,
        'password': password,
        'otpCode': otpCode,
        'fcmToken': fcmToken,
        'androidId': androidId,
        if (fatherName != null) 'fatherName': fatherName,
        if (cnic != null) 'cnic': cnic,
        if (address != null) 'address': address,
        if (dob != null) 'dob': dob,
      };
}