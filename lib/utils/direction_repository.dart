import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipet/model/directions_model.dart';
import 'package:ipet/utils/env.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': googleAPIkey,
        },
      );
      if (response.statusCode == 200) {
        return Directions.fromMap(response.data);
      } else {
        throw Exception('Failed to fetch directions');
      }
    } catch (e) {
      debugPrint('Error fetching directions: $e');
      return null;
    }
  }
}
