class RoutePoint {
  final double latitude;
  final double longitude;

  const RoutePoint({
    required this.latitude,
    required this.longitude,
  });
}

class RoadRouteModel {
  final List<RoutePoint> points;
  final double distanceMeters;
  final double durationSeconds;

  const RoadRouteModel({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  double get distanceKm => distanceMeters / 1000;

  double get durationMinutes => durationSeconds / 60;
}