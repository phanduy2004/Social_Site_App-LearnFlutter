import 'package:social_site_app/core/entity/job_type_entity.dart';
import 'package:social_site_app/core/model/either.dart';
import 'package:social_site_app/core/model/failure.dart';

abstract class JobTypeRepository{
  Future<Either<Failure, List<JobTypeEntity>>> getJobTypes();
}