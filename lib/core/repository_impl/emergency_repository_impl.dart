import 'package:social_site_app/core/datasource/emergency_remote_datasource.dart';
import 'package:social_site_app/core/entity/emergency_entity.dart';
import 'package:social_site_app/core/entity/job_type_entity.dart';

import 'package:social_site_app/core/model/either.dart';

import 'package:social_site_app/core/model/failure.dart';
import 'package:dio/dio.dart';
import '../repository/emergency_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EmergencyRepositoryImpl implements EmergencyRepository{
  final EmergencyRemoteDatasource emergencyRemoteDatasource;

  EmergencyRepositoryImpl({required this.emergencyRemoteDatasource});
  @override
  Future<Either<Failure, EmergencyEntity>> createEmergency({required String title, required String contactPhone,required String? description,required String urgency,required LatLng location,required List<String>? service,required bool shareLiveLocation,required DateTime? scheduledAt}) async {
    try {
      return Right(
          await emergencyRemoteDatasource.createEmergency(title: title, contactPhone: contactPhone, description: description, urgency: urgency, location: location, service: service, shareLiveLocation: shareLiveLocation, scheduledAt: scheduledAt),
    );
    } on DioException catch (e) {
    return Left(JobTypeFailure(message: e.response?.data['message']));
    } catch (e) {
    return Left(JobTypeFailure(message: e.toString()));
    }
  }

}
