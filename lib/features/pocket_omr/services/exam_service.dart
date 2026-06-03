import 'package:dio/dio.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../models/exam.dart';

class ExamService {
  final DioClient _dioClient;

  ExamService({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  Future<List<Exam>> fetchRecentActivities() async {
    final response = await _dioClient.dio.get(ApiConstants.examsRecent);
    final list = response.data as List<dynamic>;
    return list
        .map((e) => Exam.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Exam>> fetchExamsToCorrect({String query = ''}) async {
    final params = <String, dynamic>{};
    if (query.isNotEmpty) params['search'] = query;
    final response = await _dioClient.dio.get(
      ApiConstants.examsToCorrect,
      queryParameters: params,
    );
    final list = response.data as List<dynamic>;
    return list
        .map((e) => Exam.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<HistoryExam>> fetchHistory({String query = ''}) async {
    final params = <String, dynamic>{};
    if (query.isNotEmpty) params['search'] = query;
    final response = await _dioClient.dio.get(
      ApiConstants.examsHistory,
      queryParameters: params,
    );
    final list = response.data as List<dynamic>;
    return list
        .map((e) => HistoryExam.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Exam> fetchExamDetails(String id) async {
    final response = await _dioClient.dio.get(ApiConstants.examMobile(id));
    return Exam.fromJson(response.data as Map<String, dynamic>);
  }

  /// Uploads scanned answer sheets (image files or a .zip of images) for an
  /// exam and returns the updated exam with its (re)graded results.
  Future<Exam> uploadSheets(String examId, List<String> filePaths) async {
    final form = FormData();
    for (final path in filePaths) {
      form.files.add(
        MapEntry(
          'files',
          await MultipartFile.fromFile(
            path,
            filename: path.split('/').last,
          ),
        ),
      );
    }
    final response = await _dioClient.dio.post(
      ApiConstants.examUploadImages(examId),
      data: form,
    );
    return Exam.fromJson(response.data as Map<String, dynamic>);
  }
}
