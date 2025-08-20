import 'package:social_site_app/core/entity/job_type_entity.dart';

import '../entity/emergency_entity.dart';
import '../model/either.dart';
import '../model/failure.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class EmergencyRepository {
  Future<Either<Failure,EmergencyEntity>> createEmergency({
    required String title,
    required String contactPhone,
    required String? description,
    required String urgency,
    required LatLng location,
    required List<String> service,
    required bool shareLiveLocation,
    required DateTime? scheduledAt,
  });
}
