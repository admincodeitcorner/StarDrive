
class RideHistoryResponse {
  final String code;
  final String message;
  final RideHistoryData data;

  const RideHistoryResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory RideHistoryResponse.fromJson(Map<String, dynamic> json) {
    return RideHistoryResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      data: RideHistoryData.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }
}

class RideHistoryData {
  final List<RideHistoryModel> rides;
  final int page;
  final int pageSize;
  final bool hasMore;

  const RideHistoryData({
    required this.rides,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  factory RideHistoryData.fromJson(Map<String, dynamic> json) {
    return RideHistoryData(
      rides: (json['rides'] as List<dynamic>)
          .map(
            (ride) => RideHistoryModel.fromJson(
              ride as Map<String, dynamic>,
            ),
          )
          .toList(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      hasMore: json['hasMore'] as bool,
    );
  }
}

class RideHistoryModel {
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

  const RideHistoryModel({
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

  factory RideHistoryModel.fromJson(Map<String, dynamic> json) {
    return RideHistoryModel(
      rideId: (json['rideId'] as num).toInt(),
      yourRole: json['yourRole'] as String,
      status: json['status'] as String,
      rideDate: DateTime.parse(json['rideDate'] as String),
      pickupName: json['pickupName'] as String,
      dropName: json['dropName'] as String,
      fare: (json['fare'] as num).toDouble(),
      commissionAmount: (json['commissionAmount'] as num?)?.toDouble(),
      driverEarning: (json['driverEarning'] as num?)?.toDouble(),
      driverRating: (json['driverRating'] as num?)?.toDouble(),
      passengerRating: (json['passengerRating'] as num?)?.toDouble(),
      otherPartyName: json['otherPartyName'] as String,
      vehicleNumber: json['vehicleNumber'] as String,
      cancelledBy: json['cancelledBy'] as String?,
      cancelReason: json['cancelReason'] as String?,
    );
  }
}
