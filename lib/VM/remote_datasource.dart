import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

abstract class RemoteDatasource {
  Future<dynamic> get(String url,
      {Map<String, dynamic>? query, Map<String, dynamic>? headers});
  Future<dynamic> post(String url, dynamic data,
      {Map<String, dynamic>? headers});
  Future<dynamic> put(String url, dynamic data,
      {Map<String, dynamic>? headers});
}

var validStatusCodes = List.generate(100, (i) => 200 + i);

enum ResponseResult { error, success }

class RemoteDatasourceImpl implements RemoteDatasource {
  final Dio _dio = Dio();

  static final String? baseUrl = dotenv.env['baseurl'];

  @override
  Future<dynamic> get(String addurl,
      {Map<String, dynamic>? query, Map<String, dynamic>? headers}) async {
    var options = addHeadersToOptions(headers);
    try {
      var res = await _dio.get('$baseUrl$addurl',
          options: options, queryParameters: query);
      if (!validStatusCodes.contains(res.statusCode))
        return ResponseResult.error;
      return res;
    } catch (e) {
      Logger().e("$addurl\n$e");
      return ResponseResult.error;
    }
  }

  @override
  Future post(String addurl, dynamic data, {Map<String, dynamic>? headers}) async {
    var options = addHeadersToOptions(headers);
    try {
      var res = await _dio.post('$baseUrl$addurl', options: options, data: data);
      if (!validStatusCodes.contains(res.statusCode)) return ResponseResult.error;
      print(res.statusCode);
      return res;
    } catch (e) {
      Logger().e("$addurl\n$e");
      return ResponseResult.error;
    }
  }

  @override
  Future put(String addurl, data, {Map<String, dynamic>? headers}) async {
    var options = addHeadersToOptions(headers);
    try {
      var res = await _dio.put('$baseUrl$addurl', data: data, options: options);
      if (!validStatusCodes.contains(res.statusCode))
        return ResponseResult.error;
      return res;
    } catch (e) {
      Logger().e("$addurl\n$data\n$e");
      return ResponseResult.error;
    }
  }

  Options addHeadersToOptions(Map<String, dynamic>? additionalHeaders) {
    Map<String, dynamic> mergedHeaders = {
      'accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    };
    if (additionalHeaders != null) {
      mergedHeaders.addAll(additionalHeaders);
    }
    return Options(
      headers: mergedHeaders,
    );
  }
}
