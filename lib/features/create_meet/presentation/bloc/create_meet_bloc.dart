import 'dart:async';

import 'package:social_site_app/features/create_meet/presentation/bloc/create_meet_event.dart';
import 'package:social_site_app/features/create_meet/presentation/bloc/create_meet_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_site_app/features/meet/domain/repository/meet_repository.dart';

class CreateMeetBloc extends Bloc<CreateMeetEvent, CreateMeetState> {
  final MeetRepository meetRepository;

  CreateMeetBloc({required this.meetRepository})
    : super(CreateMeetState.intial()) {
    on<CreateMeetEvent>(onCreateMeetEvent);
  }

  Future onCreateMeetEvent(
    CreateMeetEvent event,
    Emitter<CreateMeetState> emit,
  ) async {
    emit(state.copyWith(status: CreateMeetStatus.loading));
    var result = await meetRepository.createMeets(
      title: event.title,
      description: event.description,
      time: event.time,
      location: event.location,
    );
    result.fold(
      (l) {
        emit(
          state.copyWith(
            status: CreateMeetStatus.error,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(state.copyWith(status: CreateMeetStatus.success, createdMeet: r));
      },
    );
  }
}
