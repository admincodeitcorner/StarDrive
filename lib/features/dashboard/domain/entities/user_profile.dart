class UserProfile {
  final int id;
  final String name;
  final String fatherName;
  final String cnic;
  final String contactNumber;
  final String address;
  final String role;
  final DateTime? dob;
  final bool isActive;
  final String? profilePicPath;
  final double passengerRating;
  final bool isDriver;

  const UserProfile({
    required this.id,
    required this.name,
    required this.fatherName,
    required this.cnic,
    required this.contactNumber,
    required this.address,
    required this.role,
    required this.dob,
    required this.isActive,
    required this.profilePicPath,
    required this.passengerRating,
    required this.isDriver,
  });
}