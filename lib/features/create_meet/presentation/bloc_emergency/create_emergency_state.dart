import 'package:equatable/equatable.dart';
import 'package:social_site_app/core/entity/emergency_entity.dart';

enum CreateEmergencyStatus{
  initial,
  loading,
  success,
  error
}
class CreateEmergencyState extends Equatable{
  final CreateEmergencyStatus status;
  final String? errorMessage;
  final EmergencyEntity? createdEmergency;

  const CreateEmergencyState._({required this.status,  this.errorMessage,  this.createdEmergency});

  factory CreateEmergencyState.initial() => CreateEmergencyState._(status: CreateEmergencyStatus.initial);

  CreateEmergencyState copyWith({
    CreateEmergencyStatus? status, String? errorMessage, EmergencyEntity? createEmergency}) => CreateEmergencyState._(status: status ?? this.status, errorMessage: errorMessage ?? this.errorMessage, createdEmergency: createEmergency ?? this.createdEmergency);

  @override
  List<Object?> get props => [status,errorMessage,createdEmergency];
}