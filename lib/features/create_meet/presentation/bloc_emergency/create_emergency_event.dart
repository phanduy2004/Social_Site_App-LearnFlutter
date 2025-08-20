import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/entity/job_type_entity.dart';

class CreateEmergencyEvent{
  final String title;
  final String contactPhone;

  final String urgency;           // 'low' | 'medium' | 'high'

  final String? description;
  final LatLng location;         // <-- LatLng như bạn muốn
  final List<String> services;  // JobTypeId[]
  final bool shareLiveLocation;
  final DateTime? scheduledAt;

  CreateEmergencyEvent({required this.title, required this.contactPhone, required this.urgency, required this.description, required this.location, required this.services, required this.shareLiveLocation, required this.scheduledAt});

}