import 'package:social_site_app/core/entity/meet_entity.dart';
import 'package:equatable/equatable.dart';

enum MeetStatus { initial, loading, success,left, canceled, error }

class MeetState extends Equatable{
  final MeetStatus status;
  final String? errorMessage;
  final MeetEntity? meetEntity;

  MeetState._({required this.status, this.errorMessage, this.meetEntity});

  factory MeetState.initial() => MeetState._(status: MeetStatus.initial);

  MeetState copyWith({
    MeetStatus? status,
    String? errorMessage,
    MeetEntity? meetEntity,
  }) => MeetState._(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    meetEntity: meetEntity ?? this.meetEntity,
  );

  @override
  List<Object?> get props => [status,errorMessage,meetEntity];
}
