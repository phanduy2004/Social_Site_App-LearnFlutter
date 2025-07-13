import 'package:dio/dio.dart';
import 'package:social_site_app/core/entity/job_entity.dart';
import 'package:social_site_app/core/entity/job_type_entity.dart';



class JobTypeRemoteDatasource{
  final Dio dio;

  JobTypeRemoteDatasource({required this.dio});

  Future<List<JobTypeEntity>> getJobTypes() async {
    try {
      final response = await dio.get('/job_types');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => JobTypeEntity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load job types: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching job types: $e');
    }
  }
}