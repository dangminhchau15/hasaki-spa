import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:app/src/dataresources/remote/apisubdomain.dart';
import 'package:app/src/dataresources/remote/preference_provider.dart';
import 'package:app/src/dataresources/remote/server_error_response.dart';
import 'package:http/http.dart' as http;
import 'network_service_response.dart';

class RestClient {
  String baseUrl;

  RestClient(String username) {
    if(username == "chaudm@hasaki.vn") {
      this.baseUrl = API.test;
    } else {
      this.baseUrl = API.prod;
    }
  }

  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json"
  };

  Future<MappedNetworkServiceResponse<T>> getAsync<T>(String resourcePath,
      [Map<String, String> query]) async {
    var url = Uri.http(baseUrl, resourcePath, query);
    print("URL: " + baseUrl + resourcePath);
    print("Params: " + query.toString());
    var response = await http.get(url).timeout(const Duration(seconds: 30));
    print("--> GET RESPONSE OF " + url.path + "\n" + response.body);
    return processResponse<T>(response);
  }

  Future<MappedNetworkServiceResponse<T>> getAsyncToken<T>(String resourcePath,
      [Map<String, String> query]) async {
    var token;
    await PreferenceProvider.getToken().then((result) {
      token = result;
    });
    Map<String, String> mapToken = {
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    headers.addAll(mapToken);
    var url = Uri.http(baseUrl, resourcePath, query);
    print("URL: " + baseUrl + resourcePath);
    print("Params: " + query.toString());
    print("Bearer: " + token);
    var response = await http
        .get(url, headers: headers)
        .timeout(const Duration(seconds: 30));

    print("--> GET RESPONSE OF " + url.path + "\n" + response.body);
    return processResponse<T>(response);
  }

  Future<MappedNetworkServiceResponse<T>> postAsync<T>(
      String resourcePath, dynamic data,
      [Map<String, String> query]) async {
    var url = Uri.http(baseUrl, resourcePath, query);
    print("URL: " + baseUrl + resourcePath);
    print("Params: " + query.toString());
    print("Data: " + data.toString());
    print("json: ${json.encode(data)}}");
    var response = await http.post(url,
        body: json.encode(data), headers: {"Content-Type": "application/json"});
    print("Code: " + response.statusCode.toString());
    print("--> POST RESPONSE OF " + url.path + "\n" + response.body);
    return processResponse<T>(response);
  }

  Future<MappedNetworkServiceResponse<T>> postAsyncWithToken<T>(
      String resourcePath, dynamic data,
      [Map<String, String> query]) async {
    // var content = json.encoder.convert(data);
    var token;
    await PreferenceProvider.getToken().then((result) {
      token = result;
    });
    var url = Uri.http(baseUrl, resourcePath, query);
    print("URL: " + baseUrl + resourcePath);
    print("Params: " + query.toString());
    Map<String, String> mapToken = {
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    headers.addAll(mapToken);

    // print("--> POST\n---> HEADER: $headers" + "\n---> body: " + data);

    var response =
        await http.post(url, body: json.encode(data), headers: headers);
    print(response.request.url);
    print("--> POST RESPONSE OF " + url.path + "\n" + response.body);
    return processResponse<T>(response);
  }

  Future<MappedNetworkServiceResponse<T>> putAsyncWithToken<T>(
      String resourcePath, dynamic data,
      [Map<String, String> query]) async {
    // var content = json.encoder.convert(data);
    var token;
    await PreferenceProvider.getToken().then((result) {
      token = result;
    });
    var url = Uri.http(baseUrl, resourcePath, query);
    print("URL: " + baseUrl + resourcePath);
    print("Params: " + json.encode(data).toString());
    print("Bearer: " + token);
    Map<String, String> mapToken = {
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    headers.addAll(mapToken);

    // print("--> POST\n---> HEADER: $headers" + "\n---> body: " + data);

    var response =
        await http.put(url, body: json.encode(data), headers: headers);
    print(response.request.url);
    print(response.statusCode);
    print("--> POST RESPONSE OF " + url.path + "\n" + response.body);
    return processResponse<T>(response);
  }

  MappedNetworkServiceResponse<T> processResponse<T>(http.Response response) {
    if (!((response.statusCode < 200) ||
        (response.statusCode >= 300) ||
        (response.body == null))) {
      //have data
      var jsonResult = response.body;
      var resultClass = jsonDecode(jsonResult);
      // print(jsonResult);

      return MappedNetworkServiceResponse<T>(
          mappedResult: resultClass,
          networkServiceResponse: NetworkServiceResponse<T>(isSuccess: true));
    } else {
      try {
        var resultJson = jsonDecode(response.body);
        var result = ErrorServerResponse.fromJson(resultJson);
        return MappedNetworkServiceResponse<T>(
            networkServiceResponse: NetworkServiceResponse<T>(
                statusCode: response.statusCode,
                isSuccess: false,
                message: result.message));
      } catch (e) {
        return MappedNetworkServiceResponse<T>(
            networkServiceResponse: NetworkServiceResponse<T>(
                statusCode: response.statusCode,
                isSuccess: false,
                message: "Chức năng đang cập nhật. Vui lòng thử lại sau!"));
      }
    }
  }
}
