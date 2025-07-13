import 'package:social_site_app/core/entity/meet_entity.dart';
import 'package:equatable/equatable.dart';

enum CreateMeetStatus{
  initial,
  loading,
  success,
  error
}
class CreateMeetState extends Equatable{
  final CreateMeetStatus status;
  final String? errorMessage;
  final MeetEntity? createdMeet;

  const CreateMeetState._({required this.status,  this.errorMessage,  this.createdMeet});

  factory CreateMeetState.intial() => CreateMeetState._(status: CreateMeetStatus.initial);

  CreateMeetState copyWith({
    CreateMeetStatus? status, String? errorMessage, MeetEntity? createdMeet}) => CreateMeetState._(status: status ?? this.status, errorMessage: errorMessage ?? this.errorMessage, createdMeet: createdMeet ?? this.createdMeet);

  @override
  List<Object?> get props => [status,errorMessage,createdMeet];
}