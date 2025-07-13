import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_site_app/core/entity/job_type_entity.dart';

class CreateMeetEvent{
  final String? title;
  final String? description;
  final TimeOfDay time;
  final LatLng location;
  final List<JobTypeEntity> jobTypes;
  CreateMeetEvent({this.title, this.description, required this.time, required this.location, required this.jobTypes});
}