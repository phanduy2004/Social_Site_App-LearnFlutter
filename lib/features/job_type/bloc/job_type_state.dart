import 'package:equatable/equatable.dart';
import 'package:social_site_app/core/entity/job_type_entity.dart';

enum JobTypeStatus { initial, loading, success, error }

class JobTypeState extends Equatable {
  final JobTypeStatus status;
  final String? errorMessage;
  final List<JobTypeEntity> jobTypes; // ✅ Đổi từ JobTypeEntity? sang List<JobTypeEntity>

  const JobTypeState._({
    required this.status,
    this.errorMessage,
    this.jobTypes = const [],
  });

  factory JobTypeState.initial() =>
      const JobTypeState._(status: JobTypeStatus.initial);

  JobTypeState copyWith({
    JobTypeStatus? status,
    String? errorMessage,
    List<JobTypeEntity>? jobTypes,
  }) =>
      JobTypeState._(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        jobTypes: jobTypes ?? this.jobTypes,
      );

  @override
  List<Object?> get props => [status, errorMessage, jobTypes];
}
