import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:question_app/services/networking/urls.dart';
import 'package:question_app/utils/appUtils.dart';
import '../../feature/data/models/dataModels/responseDataModel.dart';


class ApiUtils {
  // static Future<Response> getMethod(
  //         {required Uri url, Map<String, String>? headers}) =>
  //     get(url, headers: headers,);


  static Future<Response> getMethod(
      {required Uri url, Map<String, String>? headers,
        Map<String, dynamic>? body,
      }) async{
    var request = MultipartRequest('GET', url);
    if(headers != null){
      request.headers.addAll(headers);
    }
    if (body != null) {
      // Convert the body map to JSON
      var jsonBody = jsonEncode(body);

      // Set the JSON body to the request
      request.fields['_json'] = jsonBody; // You can use a custom field key if required


      // for (var entry in body.entries) {
      //   request.fields[entry.key] = entry.value.toString();
      // }
    }

    var streamedResponse = await request.send();
    var response = await Response.fromStream(streamedResponse);
    return response;
  }

  static Future<Response> patchMethod({
    required Uri url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, String>? multipartFile,
  }) async {
    if (multipartFile != null) {
      var request = MultipartRequest('PATCH', url);

      if (headers != null) {
        AppUtils.log(headers);
        request.headers.addAll(headers);
      }

      for (var entry in multipartFile.entries) {
        String fieldName = entry.key;
        String filePath = entry.value;
        request.files.add(
          await MultipartFile.fromPath(fieldName, filePath),
        );
      }

      if (body != null) {
        for (var entry in body.entries) {
          request.fields[entry.key] = entry.value.toString();
        }
      }

      var streamedResponse = await request.send();
      var response = await Response.fromStream(streamedResponse);
      return response;
    }

    return patch(url, headers: headers, body: jsonEncode(body));
  }


  static Future<Response> postMethod(
      {required Uri url,
      Map<String, String>? headers,
      Map<String, dynamic>? body,
      Map<String, String>? multipartFile}) async {
    // print(url.path);
    // AppUtils.log(Urls.appApiBaseUrl+url.path);
    AppUtils.log(Urls.api+url.path);
    AppUtils.log(headers);
    AppUtils.log(body);

    // AppUtils.log(multipartFile);
    // AppUtils.log(body);
    if (multipartFile != null) {
      var request = MultipartRequest('POST', url);
      if(headers != null){
        request.headers.addAll(headers);
      }
      for (var entry in multipartFile.entries) {
        String fieldName = entry.key;
        String filePath = entry.value;
        request.files.add(
          await MultipartFile.fromPath(fieldName, filePath),
        );
      }
      if (body != null) {
        for (var entry in body.entries) {
          request.fields[entry.key] = entry.value.toString();
        }
      }
      var streamedResponse = await request.send();
      var response = await Response.fromStream(streamedResponse);
      return response;
    } else {
      return post(url, headers: headers, body: jsonEncode(body));
    }
  }

  static Future<Response> putMethod(
      {required Uri url,
      Map<String, String>? headers,
      Map<String, dynamic>? body,
        Map<String, String>? multipartFile
      }) async{
    if (multipartFile != null) {
      var request = MultipartRequest('PUT', url);
      if(headers != null){
        AppUtils.log(headers);
        request.headers.addAll(headers);
      }

      for (var entry in multipartFile.entries) {
        String fieldName = entry.key;
        String filePath = entry.value;
        request.files.add(
          await MultipartFile.fromPath(fieldName, filePath),
        );
      }
      if (body != null) {
        for (var entry in body.entries) {
          request.fields[entry.key] = entry.value.toString();
        }
      }
      var streamedResponse = await request.send();
      var response = await Response.fromStream(streamedResponse);
      return response;
    }


    // print(url.path);
    // print(headers);
    // print(body);
    return put(url, headers: headers, body: jsonEncode(body));
  }

  static Future<Response> deleteMethod({
    required Uri url,
    Map<String, String>? headers,
    Map<String, String>? query,
  }) async {
    Uri uri = generateUri(url.toString(), query);
    return delete(uri, headers: headers);
  }



  static Future<ResponseData<Map<String, dynamic>>> call({
    Map<String, dynamic>? responseStatusValue,
    required Future<Response> request,
    required Map<String, dynamic> Function(Map<String, dynamic>) data,
    Function(ResponseData)? error,
  }) async {
    try {
      final result = await request;

      AppUtils.log(result.statusCode);
      AppUtils.log(result.body);

      final responseBody = jsonDecode(result.body) as Map<String, dynamic>;

      if (result.statusCode >= 200 && result.statusCode < 300) {
        // Checking internal API 'statusCode' if provided
        final apiStatusCode = responseBody['statusCode'];
        final apiMessage = responseBody['message'] ?? 'Unknown error';

        bool isStatusOk = responseStatusValue != null
            ? responseBody[responseStatusValue['key']] == responseStatusValue['value']
            : apiStatusCode == 200 || apiStatusCode == 201;

        if (isStatusOk) {
          return ResponseData<Map<String, dynamic>>(
            data: data(responseBody),
            statusCode: result.statusCode,
          );
        } else {
          // even for 200 HTTP, API 'statusCode' failed
          return ResponseData<Map<String, dynamic>>(
            data: responseBody,
            statusCode: result.statusCode,
            error: Exception(apiMessage),
          );
        }
      } else {
        // HTTP non-2xx status codes
        String errorMsg = _statusErrors(result.statusCode);

        try {
          final errorBody = jsonDecode(result.body) as Map<String, dynamic>;
          if (errorBody.containsKey('message')) {
            errorMsg = errorBody['message'];
          } else if (errorBody.containsKey('message')) {
            errorMsg = errorBody['message'];
          }
        } catch (e) {
          // failed to parse error body
        }

        return ResponseData<Map<String, dynamic>>(
          statusCode: result.statusCode,
          error: Exception(errorMsg),
          message: errorMsg,
        );
      }

    } catch (e) {
      return error?.call(
        ResponseData<Map<String, dynamic>>(
          error: Exception(e.toString()),
          message: e.toString(),
        ),
      ) ?? ResponseData<Map<String, dynamic>>(
        error: Exception(e.toString()),
        message: e.toString(),
      );

    }
  }



  static ResponseData<T> generateResponse<T>(T data) =>
      ResponseData(data: data);

  static Uri generateUri(String url, Map<String, String>? query) {
    Uri uri = Uri.parse(url);
    if (query != null) {
      final obj = uri.replace(queryParameters: query);
      uri = obj;
    }
    return uri;
  }

  static Map<String,String> headerGen({String? authToken, bool isMultipart = false}){
    Map<String,String> token = authToken != null ? {'Authorization':authToken} : <String,String>{};
    return {
      "Content-Type": isMultipart ? 'multipart/form-data' : "application/json",
      ...token
    };
  }


  static String _statusErrors(int statusCode) {
    String error = '';
    switch (statusCode) {
      case 400:
        error = 'Bad Request Exception';
        break;
      case 401:
        error = 'Unauthorised Exception';
        break;
      case 403:
        error = 'Access to the requested resource is forbidden';
        break;
      case 500:
        error = 'Internal Server Error';
        break;
      default:
        error = 'Unknown error: $statusCode';
        break;
    }
    return error;
  }
}
