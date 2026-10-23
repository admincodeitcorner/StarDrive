import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:star_drive/core/network/dio_client.dart';
import 'package:star_drive/features/map/data/models/road_route_models.dart';

abstract interface class RouteDataSource {
  Future<RoadRouteModel> getRoadRoute({
    required LatLng pickup,
    required LatLng destination,
  });
}

class RouteDataSourceImpl implements RouteDataSource {
  
  final DioClient dioClient;

  RouteDataSourceImpl( this.dioClient);

  // Temporary public OSRM server.
  // Later replace this with   VPS endpoint.
  static const String baseUrl =
      'https://router.project-osrm.org';

  @override
  Future<RoadRouteModel> getRoadRoute({
    required LatLng pickup,
    required LatLng destination,
  }) async {
    final coordinates =
        '${pickup.longitude},${pickup.latitude};'
        '${destination.longitude},${destination.latitude}';

    
      final uri = Uri.https(
      'router.project-osrm.org',
      '/route/v1/driving/$coordinates',
      {
        'overview': 'full',
        'geometries': 'geojson',
        'steps': 'false',
      },
    );

    debugPrint('OSRM request URL: $uri');
      
    final response = await dioClient.dio.getUri(
      uri,
      options: Options(
        responseType: ResponseType.json,
      ),
    );


    final data = Map<String, dynamic>.from(
      response.data as Map,
    );
 debugPrint("data $data");
    if (data['code'] != 'Ok') {
      throw Exception(
        'OSRM route error: ${data['code'] ?? 'Unknown error'}',
      );
    }

    final routes = data['routes'] as List<dynamic>;

    if (routes.isEmpty) {
      throw Exception('No driving route found.');
    }

    final route = Map<String, dynamic>.from(
      routes.first as Map,
    );

    final geometry = Map<String, dynamic>.from(
      route['geometry'] as Map,
    );

    final coordinatesList =
        geometry['coordinates'] as List<dynamic>;

    final points = coordinatesList.map((item) {
      final coordinate = item as List<dynamic>;

      // OSRM format: [longitude, latitude]
      return RoutePoint(
        longitude: (coordinate[0] as num).toDouble(),
        latitude: (coordinate[1] as num).toDouble(),
      );
    }).toList();

    if (points.length < 2) {
      throw Exception('Route geometry is incomplete.');
    }

    return RoadRouteModel(
      points: points,
      distanceMeters:
          (route['distance'] as num).toDouble(),
      durationSeconds:
          (route['duration'] as num).toDouble(),
    );
  }
}