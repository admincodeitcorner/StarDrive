enum UserRole {
  driver('Driver'),
  passenger('Passenger');

  const UserRole(this.value);

  final String value;

  bool get isDriver => this == UserRole.driver;
}
