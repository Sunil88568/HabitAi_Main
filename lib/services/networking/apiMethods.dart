
import 'package:question_app/services/networking/urls.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:question_app/utils/appUtils.dart';

import '../../feature/data/models/dataModels/responseDataModel.dart';
import 'apiUtils.dart';



abstract class ApiMethods {
  Future<ResponseData<Map<String, dynamic>>> get({
    required String url,
    String? authToken,
    Map<String, String>? query,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? responseStatusValue,
  });

  Future<ResponseData<Map<String, dynamic>>> post({
    required String url,
    String? authToken,
    Map<String, dynamic>? body,
    Map<String, String>? query,
    Map<String, String>? multipartFile,
    Map<String, dynamic>? responseStatusValue,
    required Map<String, String> headers,
  });

  Future<ResponseData<Map<String, dynamic>>> put({
    required String url,
    String? authToken,
    Map<String, dynamic>? body,
    Map<String, String>? query,
    Map<String, String>? multipartFile,
    Map<String, dynamic>? responseStatusValue,
    required Map<String, String> headers,
  });

  Future<ResponseData<Map<String, dynamic>>> delete({
    required String url,
    String? authToken,
    Map<String, String>? query,
    Map<String, dynamic>? responseStatusValue,
  });


  Future<ResponseData<Map<String, dynamic>>> patch({
    required String url,
    String? authToken,
    Map<String, dynamic>? body,
    Map<String, String>? query,
    Map<String, String>? multipartFile,
    Map<String, dynamic>? responseStatusValue,
    required Map<String, String> headers,
  });


}

class IApiMethod implements ApiMethods {
  String? baseUrl;

  IApiMethod({String? baseUrl}) {
    this.baseUrl = baseUrl ?? Urls.api;
  }

  @override
  Future<ResponseData<Map<String, dynamic>>> get({
    required String url,
    String? authToken,
    Map<String, String>? query,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? responseStatusValue,
  }) async {

    final effectiveHeaders = {
      ...ApiUtils.headerGen(
        authToken: authToken
      ),
      ...(headers?? {}),
    };
    final bUrl = baseUrl;
    final uri = ApiUtils.generateUri('$bUrl$url', query);
    return ApiUtils.call(
      request: ApiUtils.getMethod(
        url: uri,
        // headers: ApiUtils.headerGen(authToken: authToken),
        headers: effectiveHeaders,
        body: body
      ),
      data: (data) => data,
      error: (error) => error,
      responseStatusValue: responseStatusValue,
    );
  }

  @override
  Future<ResponseData<Map<String, dynamic>>> patch({
    required String url,
    String? authToken,
    Map<String, dynamic>? body,
    Map<String, String>? query,
    Map<String, String>? multipartFile,
    Map<String, dynamic>? responseStatusValue,
    required Map<String, String> headers,
  }) {
    final effectiveHeaders = {
      ...ApiUtils.headerGen(
        authToken: authToken,
        isMultipart: multipartFile != null,
      ),
      ...headers,
    };
    final bUrl = baseUrl;
    final uri = ApiUtils.generateUri('$bUrl$url', query);

    return ApiUtils.call(
      request: ApiUtils.patchMethod(
        url: uri,
        body: body,
        multipartFile: multipartFile,
        headers: effectiveHeaders,
      ),
      data: (data) => data,
      error: (error) => error,
      responseStatusValue: responseStatusValue,
    );
  }


  @override
  Future<ResponseData<Map<String, dynamic>>> post({
    required String url,
    String? authToken,
    Map<String, dynamic>? body,
    Map<String, String>? query,
    Map<String, String>? multipartFile,
    Map<String, dynamic>? responseStatusValue,
    required Map<String, String> headers,
  }) {
    final bUrl = baseUrl;

    AppUtils.log(url);
    final uri = ApiUtils.generateUri('$bUrl$url', query);



    final effectiveHeaders = {
      ...ApiUtils.headerGen(
        authToken: authToken,
        isMultipart: multipartFile != null,
      ),
      ...headers,
    };

    return ApiUtils.call(
      request: ApiUtils.postMethod(
        url: uri,
        body: body,
        multipartFile: multipartFile,
        headers: effectiveHeaders,
      ),
      data: (data) => data,
      error: (error) => error,
      responseStatusValue: responseStatusValue,
    );
  }


  @override
  Future<ResponseData<Map<String, dynamic>>> put({
    required String url,
    String? authToken,
    Map<String, dynamic>? body,
    Map<String, String>? query,
    Map<String, String>? multipartFile,
    Map<String, dynamic>? responseStatusValue,
    required Map<String, String> headers,
  }) {
    final effectiveHeaders = {
      ...ApiUtils.headerGen(
        authToken: authToken,
        isMultipart: multipartFile != null,
      ),
      ...headers,
    };
    final bUrl = baseUrl;
    final uri = ApiUtils.generateUri('$bUrl$url', query);
    return ApiUtils.call(
      request: ApiUtils.putMethod(
        url: uri,
        body: body,
        multipartFile: multipartFile,
        headers: effectiveHeaders,
      ),

      data: (data) => data,
      error: (error) => error,
      responseStatusValue: responseStatusValue,
    );
  }


  @override
  Future<ResponseData<Map<String, dynamic>>> delete({
    required String url,
    String? authToken,
    Map<String, String>? query,
    Map<String, dynamic>? responseStatusValue,
  }) {
    final bUrl = baseUrl;
    final uri = ApiUtils.generateUri('$bUrl$url', query);
    return ApiUtils.call(
      request: ApiUtils.deleteMethod(
        url: uri,
        headers: ApiUtils.headerGen(authToken: authToken),
      ),
      data: (data) => data,
      error: (error) => error,
      responseStatusValue: responseStatusValue,
    );
  }
}

