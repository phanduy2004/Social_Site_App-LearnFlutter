import 'package:social_site_app/features/meet/domain/entity/meet_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:equatable/equatable.dart';

enum MainStatus { initial, loading, success,successfullyGotUserLocation, error }

class MainState extends Equatable {
  final MainStatus mapStatus;
  final String? mapErrorMessage;
  final List<MeetEntity>? mapMeets;
  final LatLng? userLocation;

  MainState._({
    this.userLocation,
    required this.mapStatus,
    this.mapErrorMessage,
    this.mapMeets,
  });

  factory MainState.initial() => MainState._(mapStatus: MainStatus.initial);

  MainState copyWith({
    MainStatus? mapStatus,
    List<MeetEntity>? mapMeets,
    String? mapErrorMessage,
    LatLng? userLocation,
  }) => MainState._(
    mapStatus: mapStatus ?? this.mapStatus,
    mapMeets: mapMeets ?? this.mapMeets,
    mapErrorMessage: mapErrorMessage ?? this.mapErrorMessage,
    userLocation: userLocation ?? this.userLocation,
  );

  @override
  List<Object?> get props => [
    mapStatus,
    mapErrorMessage,
    mapMeets,
    userLocation,
  ];
}
