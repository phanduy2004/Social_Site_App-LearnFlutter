import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_site_app/features/main/presentation/bloc/main_event.dart';
import 'package:social_site_app/features/main/presentation/bloc/main_state.dart';
import 'package:social_site_app/core/repository/meet_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MainBloc extends Bloc<MainEvent,MainState>{
  final MeetRepository meetRepository;

  MainBloc({required this.meetRepository}): super(MainState.initial()){
    on<GetUserLocationEvent>(onGetUserLocationEvent);
    on<GetMapMeetsEvent>(onGetMapMeetsEvent);
    on<GetNearByMeetsEvent>(onGetNearByMeetsEvent);
    on<GetCurrentMeetsEvent>(onGetCurrentMeetsEvent);


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

  Future onGetNearByMeetsEvent(GetNearByMeetsEvent event, Emitter<MainState> emit) async {
    emit(state.copyWith(nearbyStatus: MainStatus.loading));
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
    var result = await meetRepository.getMeets(position.latitude, position.longitude, 10000);
    result.fold((l) {
      emit(state.copyWith(nearbyStatus: MainStatus.error,nearbyErrorMessage: l.message));
    }, (r) {
      emit(state.copyWith(nearbyStatus: MainStatus.success, nearbyMeets: r));
    });
  }

  Future onGetCurrentMeetsEvent(GetCurrentMeetsEvent event, Emitter<MainState> emit) async {
    emit(state.copyWith(currentMeetsStatus: MainStatus.loading));
    var result = await meetRepository.getCurrentMeets();
    result.fold((l){
      emit(state.copyWith(currentMeetsStatus: MainStatus.error,currentMeetsErrorMessage: l.message));
    }, (r){
      emit(state.copyWith(
          currentMeets: r,
          currentMeetsStatus: MainStatus.success
      ));
    });
  }
}