

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_site_app/core/repository/job_type_repository.dart';
import 'package:social_site_app/features/job_type/bloc/job_type_event.dart';
import 'package:social_site_app/features/job_type/bloc/job_type_state.dart';

class JobTypeBloc extends Bloc<JobTypeEvent, JobTypeState>{
  final JobTypeRepository jobTypeRepository;

  JobTypeBloc({required this.jobTypeRepository}): super(JobTypeState.initial()){
    on<GetJobTypeEvent>(onGetJobTypeEvent);
  }


  Future onGetJobTypeEvent(GetJobTypeEvent event, Emitter<JobTypeState> emit) async {
    emit(state.copyWith(status: JobTypeStatus.loading));
    var result = await jobTypeRepository.getJobTypes();
    result.fold((l) {
      emit(state.copyWith(status: JobTypeStatus.error, errorMessage: l.message));
    }, (r) {
      emit(state.copyWith(status: JobTypeStatus.success, jobTypes: r)); // ✅ r là List<JobTypeEntity>
    });
  }

}