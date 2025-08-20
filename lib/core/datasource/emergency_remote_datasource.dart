import 'package:dio/dio.dart';
import 'package:social_site_app/core/entity/emergency_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_site_app/core/entity/job_type_entity.dart';

class EmergencyRemoteDatasource{
  final Dio dio;

  EmergencyRemoteDatasource({required this.dio});

  Future<EmergencyEntity> createEmergency({
    required String title,
    required String contactPhone,
    required String? description,
    required String urgency,
    required LatLng location,
    required List<String>? service,
    required bool shareLiveLocation,
    required DateTime? scheduledAt,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'contactPhone': contactPhone,
      'urgency': urgency,
      'shareLiveLocation': shareLiveLocation,
      if (description != null && description.isNotEmpty) 'description': description,
      'latitude': location.latitude,
      'longitude': location.longitude,
      if (service != null && service.isNotEmpty) 'service': service,
      if (scheduledAt != null) 'scheduledAt': scheduledAt.toIso8601String(),
    };
    final res = await dio.post('/emergencies/', data: body);
    return EmergencyEntity.fromJson(res.data as Map<String, dynamic>);
  }
}