import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_flutter/talker_flutter.dart';

abstract class DioRegistrant {
  static Dio register(Talker talker) {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.interceptors.add(TalkerDioLogger(talker: talker));
    return dio;
  }
}
