class RegistrationData {
  final String name;
  final String contactNumber;
  final String role;
  final String password;
  final String fcmToken;
  final String androidId;


  final String? fatherName;
  final String? cnic;
  final String? address;
  final String? dob;

  const RegistrationData({
    required this.name,
    required this.contactNumber,
    required this.role,
    required this.password,
    required this.fcmToken,
    required this.androidId,
    this.fatherName,
    this.cnic,
    this.address,
    this.dob,
  });
}