import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:taskapp/constant/api_constants.dart';
import 'package:taskapp/constant/api_feature.dart';
import 'package:taskapp/constant/app_string.dart';
import 'package:taskapp/helpers/app_exception.dart';
import 'package:taskapp/services/network_services.dart';
import 'package:taskapp/widgets/api_error_dilaog.dart';

enum ApiMethod { get, post, delete, put }

class ApiProvider {
  String? baseUrl;
  String? origin;
  String? authToken;

  final http.Client _client;

  ApiProvider(this._client, {this.baseUrl}) {
    baseUrl = AppString.baseUrl;
    origin = AppString.baseUrl;
  }

  final _networkService = NetworkService.instance;

//---------------------------------------------------APIS METHODS-------------------------------------------------------------------------------

//login
  Future<ResponseData> createTask(Map<String, dynamic> body) async {
    final response = await _catchAsyncApiError(
      endPoint: APIConstants.creatTaskUri,
      method: ApiMethod.post,
      feature: ApiFeature.creatTask,
      body: body,
    );

    return response;
  }

  Future<ResponseData> createTasks(Map<String, dynamic> body) async {
    final response = await _catchAsyncApiError(
      endPoint: APIConstants.creatTasksUri,
      method: ApiMethod.post,
      feature: ApiFeature.creatTaskBulk,
      body: body,
    );

    return response;
  }

//login
  Future<ResponseData> getAllTask() async {
    final response = await _catchAsyncApiError(
      endPoint: APIConstants.getAllTaskUri,
      method: ApiMethod.get,
      feature: ApiFeature.getAllask,
    );

    return response;
  }

  Future<ResponseData> updateTask(String taskID, Map<String, dynamic> body) async {
    final response = await _catchAsyncApiError(
      endPoint: APIConstants.updateTaskUri(taskID),
      method: ApiMethod.put,
      feature: ApiFeature.updateTask,
      body: body,
    );

    return response;
  }

//-----------------------------------------------------------------------------------------------------------------------------------

  Future<ResponseData> _catchAsyncApiError({
    String? baseUrl,
    required String endPoint,
    required ApiMethod method,
    required String feature,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      log('$feature Request');

      if (_networkService.isConnected == false) {
        log('Error: No network connection');
        // RouteService.set(RouteStatus.noNetwork);
        return ResponseData(data: "Error: No network connection", isSuccessful: false);
      }
      if (this.baseUrl == null && baseUrl == null) {
        showErrorDialog("Base url not found!", "Base URL");
        return ResponseData(data: "Error: Base url not found!", isSuccessful: false);
      }

      var url = Uri.parse((baseUrl ?? this.baseUrl!) + endPoint);

      if (queryParams != null && queryParams.isNotEmpty) {
        url = url.replace(queryParameters: queryParams);
      }

      log('URL: $url');

      var headersWithContentType = {
        "content-type": "application/json",
        "Cache-Control": "no-cache",
      };

      if (headers != null) {
        headersWithContentType.addAll(headers);
      }

      switch (method) {
        /// GET request
        case ApiMethod.get:
          var response = await _client.get(
            url,
            headers: headersWithContentType,
          );

          var decodedData = json.decode(utf8.decode(response.bodyBytes));

          if (response.isSuccessfull) {
            log('$feature Request Success');
            return ResponseData(data: decodedData, isSuccessful: true);
          } else {
            log('$feature Request Error');
            log('Error: ${response.statusCode} ${response.reasonPhrase} ${response.body}');
            _showGetRequestWarningDialog(response);
            return ResponseData(data: decodedData, isSuccessful: false);
          }

        /// POST request
        case ApiMethod.post:
          var response = await _client.post(
            url,
            body: json.encode(body),
            headers: headersWithContentType,
          );

          if (response.isSuccessfull) {
            var decodedData = json.decode(utf8.decode(response.bodyBytes));
            log('$feature Request Success');
            return ResponseData(data: decodedData, isSuccessful: true);
          } else {
            log('$feature Request Error');
            log('Error: ${response.statusCode} ${response.reasonPhrase} ${response.body}');
            _showPostRequestWarningDialog(response);
            return ResponseData(data: response, isSuccessful: false);
          }

        /// PUT request
        case ApiMethod.put:
          var response = await _client.put(
            url,
            body: json.encode(body),
            headers: headersWithContentType,
          );

          var decodedData = jsonDecode(utf8.decode(response.bodyBytes));

          if (response.statusCode == 200 || response.statusCode == 201) {
            log('$feature Request Success');
            return ResponseData(data: decodedData, isSuccessful: true);
          } else {
            log('$feature Request Error');
            log('Error: ${response.statusCode} ${response.reasonPhrase} ${response.body}');
            return ResponseData(data: decodedData, isSuccessful: false);
          }

        /// DELETE request
        case ApiMethod.delete:
          var response = await _client.delete(
            url,
            headers: headersWithContentType,
          );

          var decodedData = jsonDecode(utf8.decode(response.bodyBytes));

          if (response.statusCode == 200 || response.statusCode == 201) {
            log('$feature Request Success');
            return ResponseData(data: decodedData, isSuccessful: true);
          } else {
            log('$feature Request Error');
            log('Error: ${response.statusCode} ${response.reasonPhrase} $decodedData');
            return ResponseData(data: decodedData, isSuccessful: false);
          }
      }
    } catch (e) {
      if (e is SocketException) {
        log('$feature Request Error');
        throw AppException('Error : Failed to connect to the server $e');
      } else if (e is FormatException) {
        log('$feature Request Error');
        throw AppException('Error : Format Exception');
      } else if (e is TimeoutException) {
        log('$feature Request Error');
        throw AppException('Error : Request Timeout');
      } else {
        log('$feature Request Error');
        throw AppException('$e');
      }
    }
  }

  void _showGetRequestWarningDialog(http.Response response) {
    if (response.statusCode == 401) {
      // Unauthorized
      showErrorDialog("Unauthorized access", "Error");
    } else if (response.statusCode == 408) {
      // Request Timeout
      showErrorDialog("Request timeout", "Error");
    } else if (response.statusCode == 500) {
      // Internal Server Error
      try {
        var errorJson = json.decode(response.body);
        var errorMessage = errorJson['message'] ?? "Internal server error";
        showErrorDialog(errorMessage, "Error");
      } catch (e) {
        showErrorDialog("Internal server error", "Error");
      }
    } else {
      showErrorDialog("Something went wrong", "Error");
    }
  }

  void _showPostRequestWarningDialog(http.Response response) {
    if (response.statusCode == 401) {
      // Unauthorized
      showErrorDialog("Unauthorized access", "Error");
    } else if (response.statusCode == 400) {
      // Bad Request
      try {
        var errorJson = json.decode(response.body);
        var errorMessage = errorJson['message'] ?? "Unknown error";
        showErrorDialog(errorMessage, "Error");
      } catch (e) {
        showErrorDialog("Invalid request", "Error");
      }
    } else if (response.statusCode == 408) {
      // Request Timeout
      showErrorDialog("Request timeout", "Error");
    } else if (response.statusCode == 500) {
      // Internal Server Error
      try {
        var errorJson = json.decode(response.body);
        var errorMessage = errorJson['message'] ?? "Internal server error";
        showErrorDialog(errorMessage, "Error");
      } catch (e) {
        showErrorDialog("Internal server error", "Error");
      }
    } else if (response.statusCode == 413) {
      // Payload Too Large
      showErrorDialog("Failed", "403");
    } else {
      showErrorDialog("Something went wrong", "Error");
    }
  }

  void showErrorDialog(String message, String title) async => await Get.dialog(
        ApiErrorDialog(title: title, message: message),
      );
}

class ResponseData {
  ResponseData({
    required this.data,
    required this.isSuccessful,
  });

  dynamic data;
  bool isSuccessful;
}

extension HttpResponseExtension on http.Response {
  bool get isSuccessfull => statusCode >= 200 && statusCode < 300;
}
