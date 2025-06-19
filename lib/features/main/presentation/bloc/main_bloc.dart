import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_site_app/features/main/presentation/bloc/main_event.dart';
import 'package:social_site_app/features/main/presentation/bloc/main_state.dart';
import 'package:social_site_app/features/meet/domain/repository/meet_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MainBloc extends Bloc<MainEvent,MainState>{
  final MeetRepository meetRepository;

  MainBloc({required this.meetRepository}): super(MainState.initial()){
    on<GetUserLocationEvent>(onGetUserLocationEvent);
    on<GetMapMeetsEvent>(onGetMapMeetsEvent);

  }



  Future onGetUserLocationEvent(GetUserLocationEvent event, Emitter<MainState> emit) async {
    emit(state.copyWith(mapStatus: MainStatus.loading));
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.deniedForever){
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    emit(state.copyWith(mapStatus: MainStatus.successfullyGotUserLocation,
      userLocation: LatLng(position.latitude, position.longitude)
    ));
  }

  Future onGetMapMeetsEvent(GetMapMeetsEvent event, Emitter<MainState> emit) async {
    emit(state.copyWith(mapStatus: MainStatus.loading));
    var result = await meetRepository.getMeets(event.center.latitude, event.center.longitude, event.radius);
    result.fold((l) {
      emit(state.copyWith(mapStatus: MainStatus.error,mapErrorMessage: l.message));
    }, (r) {
      emit(state.copyWith(mapStatus: MainStatus.success, mapMeets: r));
    });
  }
}