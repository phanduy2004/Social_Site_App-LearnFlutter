import 'package:dio/dio.dart';

import 'package:social_site_app/core/datasource/job_type_remote_datasource.dart';
import 'package:social_site_app/core/entity/job_type_entity.dart';
import 'package:social_site_app/core/model/either.dart';
import 'package:social_site_app/core/model/failure.dart';

import '../repository/job_type_repository.dart';

class JobTypeRepositoryImpl implements JobTypeRepository{
  final JobTypeRemoteDatasource jobTypeRemoteDatasource;

  JobTypeRepositoryImpl({required this.jobTypeRemoteDatasource});

  @override
  Future<Either<Failure, List<JobTypeEntity>>> getJobTypes() async {
    try {
      return Right(
          await jobTypeRemoteDatasource.getJobTypes(),
    );
    } on DioException catch (e) {
    return Left(JobTypeFailure(message: e.response?.data['message']));
    } catch (e) {
    return Left(JobTypeFailure(message: e.toString()));
    }
  }
}