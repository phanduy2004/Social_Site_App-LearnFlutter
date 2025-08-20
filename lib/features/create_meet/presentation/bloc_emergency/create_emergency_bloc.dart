import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_site_app/core/repository/emergency_repository.dart';

import 'create_emergency_event.dart';
import 'create_emergency_state.dart';

class CreateEmergencyBloc extends Bloc<CreateEmergencyEvent, CreateEmergencyState> {
  final EmergencyRepository emergencyRepository;

  CreateEmergencyBloc({required this.emergencyRepository})
      : super(CreateEmergencyState.initial()) {
    on<CreateEmergencyEvent>(_onCreateEmergencyEvent);
  }

  Future<void> _onCreateEmergencyEvent(
      CreateEmergencyEvent event,
      Emitter<CreateEmergencyState> emit,
      ) async {
    emit(state.copyWith(status: CreateEmergencyStatus.loading));

    final result = await emergencyRepository.createEmergency(
      title: event.title,
      contactPhone: event.contactPhone,
      description: event.description,
      urgency: event.urgency,
      location: event.location,
      service: event.services,
      shareLiveLocation: event.shareLiveLocation,
      scheduledAt: event.scheduledAt,
    );

    result.fold(
          (l) => emit(
        state.copyWith(
          status: CreateEmergencyStatus.error,
          errorMessage: l.message,
        ),
      ),
          (r) => emit(
        state.copyWith(
          status: CreateEmergencyStatus.success,
          createEmergency: r,
        ),
      ),
    );
  }
}
