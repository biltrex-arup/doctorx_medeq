import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:madeq/domain/constants/appexceptions.dart';
import 'package:madeq/domain/constants/appprefs.dart';

class ApiHelper {
  static const String baseUrl = "http://192.168.31.72:3001/api";

  ApiHelper();

  Future<dynamic> _request({
    required String path,
    required String method,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    bool isHeaderRequired = false,
  }) async {
    final uri = Uri.parse("$baseUrl$path").replace(queryParameters: queryParams);

    String? accessToken;
    if (isHeaderRequired) {
      accessToken = await AppPrefs.getAccessToken();
    }

    final headers = {
      "Content-Type": "application/json",
      if (isHeaderRequired && accessToken != null)
        "Authorization": "Bearer $accessToken",
    };

    try {
      late http.Response response;

      switch (method) {
        case "POST":
          response = await http.post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;

        case "GET":
          response = await http.get(uri, headers: headers);
          break;

        case "PUT":
          response = await http.put(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;

        case "DELETE":
          response = await http.delete(uri, headers: headers);
          break;

        default:
          throw FetchDataException(errormsg: "Unsupported HTTP method");
      }

      return jsonResponse(response);

    } on SocketException {
      throw FetchDataException(errormsg: "No Internet Connection");
    } catch (ex) {
      throw FetchDataException(errormsg: ex.toString());
    }
  }

  Future<dynamic> getApi({
    required String path,
    Map<String, dynamic>? queryParams,
    bool isHeaderRequired = false,
  }) {
    return _request(
      path: path,
      method: "GET",
      queryParams: queryParams,
      isHeaderRequired: isHeaderRequired,
    );
  }

  Future<dynamic> postApi({
    required String path,
    Map<String, dynamic>? body,
    bool isHeaderRequired = false,
  }) {
    return _request(
      path: path,
      method: "POST",
      body: body,
      isHeaderRequired: isHeaderRequired,
    );
  }

  Future<dynamic> putApi({
    required String path,
    Map<String, dynamic>? body,
    bool isHeaderRequired = false,
  }) {
    return _request(
      path: path,
      method: "PUT",
      body: body,
      isHeaderRequired: isHeaderRequired,
    );
  }

  Future<dynamic> deleteApi({
    required String path,
    bool isHeaderRequired = false,
  }) {
    return _request(
      path: path,
      method: "DELETE",
      isHeaderRequired: isHeaderRequired,
    );
  }
}

dynamic jsonResponse(http.Response res) {
  switch (res.statusCode) {
    case 200:
    case 201:
      return jsonDecode(res.body);

    case 400:
      throw BadRequestException(errormsg: res.body.toString());

    case 401:
      throw UnauthorizedException(errormsg: "Unauthorized");

    case 403:
      throw UnauthorizedException(errormsg: "Forbidden");

    case 404:
      throw FetchDataException(errormsg: "Not Found");

    case 500:
      throw FetchDataException(errormsg: "Internal Server Error");

    default:
      throw FetchDataException(errormsg: res.body.toString());
  }
}
