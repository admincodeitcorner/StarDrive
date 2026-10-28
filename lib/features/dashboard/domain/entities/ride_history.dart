
class RideHistory {
  final String code;
  final String message;
  final List<RideHistoryItem> rides;
  final int page;
  final int pageSize;
  final bool hasMore;

  const RideHistory({
    required this.code,
    required this.message,
    required this.rides,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });
}

class RideHistoryItem {
  final int rideId;
  final String yourRole;
  final String status;
  final DateTime rideDate;
  final String pickupName;
  final String dropName;
  final double fare;
  final double? commissionAmount;
  final double? driverEarning;
  final double? driverRating;
  final double? passengerRating;
  final String otherPartyName;
  final String vehicleNumber;
  final String? cancelledBy;
  final String? cancelReason;

  const RideHistoryItem({
    required this.rideId,
    required this.yourRole,
    required this.status,
    required this.rideDate,
    required this.pickupName,
    required this.dropName,
    required this.fare,
    this.commissionAmount,
    this.driverEarning,
    this.driverRating,
    this.passengerRating,
    required this.otherPartyName,
    required this.vehicleNumber,
    this.cancelledBy,
    this.cancelReason,
  });
}
