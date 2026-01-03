import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bill_n_stock/helper/Util.dart';
import 'package:bill_n_stock/api/ApiManager.dart';
import 'package:bill_n_stock/api/ApiResponseStatus.dart';
import 'package:bill_n_stock/model/user_model.dart';
import 'package:bill_n_stock/helper/pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  ApiServices._();

  static final instance = ApiServices._();
  UserModel? user;

  Map<String, String> headers = {'Content-Type': 'application/json'};

  String baseUrl = BaseUrl.local.url;
  //   var logger = Logger(
  //   printer: PrettyPrinter(
  //       methodCount: 2, // Number of method calls to be displayed
  //       errorMethodCount: 8, // Number of method calls if stacktrace is provided
  //       lineLength: 120, // Width of the output
  //       colors: true, // Colorful log messages
  //       printEmojis: true, // Print an emoji for each log message
  //       // Should each log print contain a timestamp
  //       dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  //   ),
  // );

  // Set Header
  // void setHeader(BuildContext context) {
  //   var language = "gu";
  //   // if (Util.isContextValid(context)) {
  //   //   try {
  //   //     language = Provider.of<AppState>(context, listen: false)
  //   //         .selectedLocal
  //   //         .name
  //   //         .toUpperCase();
  //   //   } catch (_) {}
  //   // }
  //   headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer ${user?.token}',
  //     // 'fromService': 'true',
  //     'userId': '${user?.userId ?? 0}',
  //     'language': language,
  //   };
  // }
  void setHeader({bool requireAuth = true}) {
    headers = {'Content-Type': 'application/json', 'language': 'gu'};

    if (requireAuth && user?.token != null && user!.token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${user!.token}';
      headers['userId'] = '${user!.userId}';
    }
  }

  Future<HttpClient> createSecuredClient() async {
    SecurityContext context = SecurityContext(withTrustedRoots: false);

    try {
      final sslCert = await rootBundle.load(
        'assets/certificates/wildcard_krushipragati_co_in.crt',
      );
      // final sslCert = await rootBundle.load('assets/certificates/wildcard_amnex_co_in_full_chain.crt');

      context.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());
    } catch (e) {
      print("Error loading certificate: $e");
    }

    HttpClient client = HttpClient(context: context);
    client.badCertificateCallback = (cert, host, port) {
      // Perform additional checks if necessary
      return false; // Reject untrusted certificates
    };
    return client;
  }

  Future<Result<dynamic, HttpException>> makePostRequest(
    dynamic params,
    UrlEndPoint endPoint,
    BuildContext context, {
    String attachUrl = "",
    bool isLoader = true,
  }) async {
    log("🔥 makePostRequest reached");

    if (!(await Util().isNetworkConnected())) {
      return Failure(HttpException("No internet connection..."));
    }

    if (isLoader) {
      EasyLoading.show(
        status: 'Loading...',
        maskType: EasyLoadingMaskType.clear,
      );
    }

    final bool isAuthFreeApi =
        endPoint == UrlEndPoint.login || endPoint == UrlEndPoint.register;

    if (!isAuthFreeApi) {
      user = await Pref.getUserModelValue(PreferenceKey.userData.toString());
    }

    setHeader(requireAuth: !isAuthFreeApi);

    String url = baseUrl + endPoint.stringValue + attachUrl;

    log('Url: $url');
    log('Params: ${jsonEncode(params)}');
    log('Headers: $headers');

    try {
      final response = await http
          .post(Uri.parse(url), body: jsonEncode(params), headers: headers)
          .timeout(const Duration(seconds: 180));

      if (isLoader) EasyLoading.dismiss();

      final decodedBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedBody);
      log('Response: $data');

      switch (response.statusCode) {
        case 200:
          // API success but might be logical error
          if ((data["status"] ?? "").toString().toLowerCase() == "success" ||
              (data["responseCode"] != null &&
                  data["responseCode"] is int &&
                  data["responseCode"] >= 200 &&
                  data["responseCode"] < 399)) {
            return Success(data);
          } else {
            // Use message fallback
            final message =
                data["responseMessage"] ?? data["message"] ?? "Unknown error";
            return Failure(HttpException(message));
          }

        case 401:
          logoutUser(context);
          return Failure(HttpException("Unauthorized"));

        default:
          final message =
              data["responseMessage"] ??
              data["message"] ??
              response.reasonPhrase ??
              "Unknown error";
          return Failure(HttpException(message));
      }
    } on TimeoutException catch (_) {
      if (isLoader) EasyLoading.dismiss();
      return Failure(HttpException("Request timeout..."));
    } on HttpException catch (e) {
      if (isLoader) EasyLoading.dismiss();
      return Failure(e);
    } catch (e) {
      if (isLoader) EasyLoading.dismiss();
      return Failure(
        HttpException(
          "Something went wrong, please try again later. Error: $e",
        ),
      );
    }
  }

  // Future<Result<dynamic, HttpException>> makePostRequest(
  //   dynamic params,
  //   UrlEndPoint endPoint,
  //   BuildContext context, {
  //   String attachUrl = "",
  //   bool isLoader = true,
  // }) async {
  //   if (!(await Util().isNetworkConnected())) {
  //     return Failure(HttpException("No internet connection..."));
  //   }

  //   if (isLoader) {
  //     EasyLoading.show(
  //       status: 'Loading...',
  //       maskType: EasyLoadingMaskType.clear,
  //     );
  //   }

  //   user = await Pref.getUserModelValue(PreferenceKey.userData.toString());

  //   setHeader();

  //   String url = baseUrl + endPoint.stringValue + attachUrl;

  //   log('Url: $url');
  //   log('Params: ${jsonEncode(params)}');
  //   log('Headers: $headers');

  //   try {
  //     final response = await http
  //         .post(Uri.parse(url), body: jsonEncode(params), headers: headers)
  //         .timeout(const Duration(seconds: 180));
  //     log('Response: $response');
  //     if (isLoader) {
  //       EasyLoading.dismiss();
  //     }
  //     switch (response.statusCode) {
  //       case 200:
  //         final decodedBody = utf8.decode(response.bodyBytes);
  //         final data = jsonDecode(decodedBody);
  //         // final data = jsonDecode(response.body);
  //         log('Response: $data');
  //         // 2. return Success with the desired value
  //         if (data["responseCode"] == null) {
  //           if (data["status"] == "success") {
  //             return Success(data);
  //           } else {
  //             return Failure(HttpException(data["responseMessage"]));
  //           }
  //         } else {
  //           switch (data["responseCode"]) {
  //             case >= 200 && < 399:
  //               return Success(data);
  //             default:
  //               return Failure(HttpException(data["responseMessage"]));
  //           }
  //         }
  //       case 401:
  //         logoutUser(context);
  //         return Failure(HttpException("Multiple Login"));
  //       default:
  //         // 3. return Failure with the desired exception
  //         return Failure(HttpException(response.reasonPhrase.toString()));
  //     }
  //   } on HttpException catch (e) {
  //     // 4. return Failure here too
  //     if (isLoader) {
  //       EasyLoading.dismiss();
  //     }
  //     return Failure(e);
  //   } on TimeoutException catch (_) {
  //     if (isLoader) {
  //       EasyLoading.dismiss();
  //     }
  //     return Failure(HttpException("Request timeout..."));
  //   } on Exception catch (e) {
  //     if (isLoader) {
  //       EasyLoading.dismiss();
  //     }
  //     return Failure(HttpException(e.toString()));
  //   } catch (e) {
  //     if (isLoader) {
  //       EasyLoading.dismiss();
  //     }
  //     return Failure(HttpException(e.toString()));
  //   }
  // }

  //Post Request

  //Get Request
  Future<Result<dynamic, HttpException>> makeGetRequest(
    UrlEndPoint endPoint,
    BuildContext context, {
    bool isLoader = true,
  }) async {
    if (!(await Util().isNetworkConnected())) {
      return Failure(HttpException("No internet connection..."));
    }
    if (isLoader) {
      EasyLoading.show(
        status: 'Loading...',
        maskType: EasyLoadingMaskType.clear,
      );
    }

    user = await Pref.getUserModelValue(PreferenceKey.userData.toString());

    setHeader();

    String url = baseUrl + endPoint.stringValue;

    log('Url: $url');
    log('Headers: $headers');

    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 180));
      if (isLoader) {
        EasyLoading.dismiss();
      }

      switch (response.statusCode) {
        case 200:
          //  final data = jsonDecode(response.body);
          final decodedBody = utf8.decode(response.bodyBytes);
          final data = jsonDecode(decodedBody);

          log('Response: $data');
          if (data["responseCode"] == null) {
            if (data["status"] == "success") {
              return Success(data);
            } else {
              return Failure(HttpException(data["responseMessage"]));
            }
          } else {
            log('data["responseCode"]: $data["responseCode"]');
            switch (data["responseCode"]) {
              case >= 200 && < 399:
                return Success(data);
              default:
                return Failure(HttpException(data["responseMessage"]));
            }
          }

        case 401:
          logoutUser(context);
          return Failure(HttpException("Multiple Login"));
        default:
          // 3. return Failure with the desired exception
          return Failure(HttpException(response.reasonPhrase.toString()));
      }
    } on HttpException catch (e) {
      // 4. return Failure here too
      if (isLoader) {
        EasyLoading.dismiss();
      }
      return Failure(e);
    } on TimeoutException catch (_) {
      if (isLoader) {
        EasyLoading.dismiss();
      }
      return Failure(HttpException("Request timeout..."));
    } catch (e) {
      if (isLoader) {
        EasyLoading.dismiss();
      }
      return Failure(HttpException(e.toString()));
    }
  }

  Future<Result<dynamic, HttpException>> makePUTMultipartRequest(
    Map<String, dynamic> params,
    List<http.MultipartFile> ducuments,
    UrlEndPoint endPoint,
    BuildContext context, {
    String jsonKey = "data",
    bool isLoader = true,
  }) async {
    if (!(await Util().isNetworkConnected())) {
      return Failure(HttpException("No internet connection..."));
    }
    if (isLoader) {
      EasyLoading.show(
        status: 'Loading...',
        maskType: EasyLoadingMaskType.clear,
      );
    }

    user = await Pref.getUserModelValue(PreferenceKey.userData.toString());

    setHeader();

    String url = baseUrl + endPoint.stringValue;

    log('Url: $url');
    log('Params: ${json.encode(params).toString()}');
    log('Headers: $headers');

    try {
      Map<String, String> obj = {jsonKey: json.encode(params).toString()};
      var request = http.MultipartRequest('PUT', Uri.parse(url))
        ..fields.addAll(obj)
        ..headers.addAll(headers)
        ..files.addAll(ducuments);

      final streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (isLoader) {
        EasyLoading.dismiss();
      }
      switch (response.statusCode) {
        case 200:
          //final data = jsonDecode(response.body);

          final decodedBody = utf8.decode(response.bodyBytes);
          final data = jsonDecode(decodedBody);
          log('Response: $data');
          // 2. return Success with the desired value
          if (data["responseCode"] == null) {
            if (data["status"] == "success") {
              return Success(data);
            } else {
              return Failure(HttpException(data["responseMessage"]));
            }
          } else {
            switch (data["responseCode"]) {
              case >= 200 && < 399:
                return Success(data);
              default:
                return Failure(HttpException(data["responseMessage"]));
            }
          }
        case 401:
          logoutUser(context);
          return Failure(HttpException("Multiple Login"));
        default:
          // 3. return Failure with the desired exception
          return Failure(HttpException(response.reasonPhrase.toString()));
      }
    } on HttpException catch (e) {
      // 4. return Failure here too
      if (isLoader) {
        EasyLoading.dismiss();
      }
      return Failure(e);
    } on Exception catch (e) {
      if (isLoader) {
        EasyLoading.dismiss();
      }
      return Failure(HttpException(e.toString()));
    } catch (e) {
      if (isLoader) {
        EasyLoading.dismiss();
      }
      return Failure(HttpException(e.toString()));
    }
  }

  Future<Result<dynamic, HttpException>> makePostMultipartRequest(
    Map<String, dynamic> params,
    List<http.MultipartFile> ducuments,
    UrlEndPoint endPoint,
    BuildContext context, {
    String jsonKey = "data",
    bool isLoader = true,
  }) async {
    if (!(await Util().isNetworkConnected())) {
      return Failure(HttpException("No internet connection..."));
    }
    if (isLoader) {
      EasyLoading.show(
        status: 'Loading...',
        maskType: EasyLoadingMaskType.clear,
      );
    }

    user = await Pref.getUserModelValue(PreferenceKey.userData.toString());

    setHeader();

    String url = baseUrl + endPoint.stringValue;

    log('Url: $url');
    log('Params: ${json.encode(params).toString()}');
    log('Headers: $headers');

    try {
      Map<String, String> obj = {jsonKey: json.encode(params).toString()};
      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields.addAll(obj)
        ..headers.addAll(headers)
        ..files.addAll(ducuments);

      final streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (isLoader) {
        EasyLoading.dismiss();
      }
      switch (response.statusCode) {
        case 200:
          final data = jsonDecode(response.body);
          log('Response: $data');
          // 2. return Success with the desired value
          if (data["responseCode"] == null) {
            if (data["status"] == "success") {
              return Success(data);
            } else {
              return Failure(HttpException(data["responseMessage"]));
            }
          } else {
            switch (data["responseCode"]) {
              case >= 200 && < 399:
                return Success(data);
              default:
                return Failure(HttpException(data["responseMessage"]));
            }
          }
        case 401:
          logoutUser(context);
          return Failure(HttpException("Multiple Login"));
        default:
          // 3. return Failure with the desired exception
          return Failure(HttpException(response.reasonPhrase.toString()));
      }
    } on HttpException catch (e) {
      // 4. return Failure here too
      if (isLoader) {
        EasyLoading.dismiss();
      }
      return Failure(e);
    } on Exception catch (e) {
      if (isLoader) {
        EasyLoading.dismiss();
      }
      return Failure(HttpException(e.toString()));
    } catch (e) {
      if (isLoader) {
        EasyLoading.dismiss();
      }
      return Failure(HttpException(e.toString()));
    }
  }

  Future<Result<dynamic, HttpException>> makePostMultipartMultipleImageRequest(
    Map<String, dynamic> params,
    List<http.MultipartFile> documents,
    UrlEndPoint endPoint,
    BuildContext context, {
    String jsonKey = "data",
    bool isLoader = true,
  }) async {
    if (!(await Util().isNetworkConnected())) {
      return Failure(HttpException("No internet connection..."));
    }

    if (isLoader) {
      EasyLoading.show(
        status: 'Loading...',
        maskType: EasyLoadingMaskType.clear,
      );
    }

    setHeader();

    String url = baseUrl + endPoint.stringValue;

    log('Url: $url');
    log('Params: ${json.encode(params)}');
    log('Headers: $headers');

    try {
      // Create secure client
      var httpClient = await createSecuredClient();

      // Build POST request
      final HttpClientRequest request = await httpClient
          .postUrl(Uri.parse(url))
          .timeout(const Duration(seconds: 180));

      headers.forEach((key, value) => request.headers.set(key, value));

      // Create multipart/form-data boundary
      const boundary = "----FlutterBoundary";
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        "multipart/form-data; boundary=$boundary",
      );

      final builder = StringBuffer();

      // Add JSON data field
      final jsonString = jsonEncode(params);
      builder.write("--$boundary\r\n");
      builder.write('Content-Disposition: form-data; name="$jsonKey"\r\n');
      builder.write("Content-Type: application/json; charset=UTF-8\r\n\r\n");
      builder.write("$jsonString\r\n");

      request.add(utf8.encode(builder.toString()));

      // Add each file
      for (var file in documents) {
        builder.clear();
        final safeFilename = Uri.encodeComponent(
          (file.filename ?? "").replaceAll(" ", "_"),
        );
        builder.write("--$boundary\r\n");
        builder.write(
          'Content-Disposition: form-data; name="${file.field}"; filename="$safeFilename"\r\n',
        );
        builder.write("Content-Type: ${file.contentType}\r\n\r\n");

        request.add(utf8.encode(builder.toString()));

        // Stream file data
        await request.addStream(file.finalize());

        request.add(utf8.encode("\r\n"));
      }

      // End boundary
      request.add(utf8.encode("--$boundary--\r\n"));

      // Send request and get response
      final HttpClientResponse response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      log("Raw Response Body: $responseBody");

      if (isLoader) {
        EasyLoading.dismiss();
      }

      switch (response.statusCode) {
        case 200:
          final data = jsonDecode(responseBody);
          log('Response: $data');

          if (data["responseCode"] == null) {
            return Success(data);
          } else {
            switch (data["responseCode"]) {
              case >= 200 && < 399:
                return Success(data);
              default:
                return Failure(HttpException(data["responseMessage"]));
            }
          }

        case 401:
          logoutUser(context);
          return Failure(HttpException("Session Expire"));

        default:
          return Failure(HttpException(response.reasonPhrase.toString()));
      }
    } on HttpException catch (e) {
      if (isLoader) EasyLoading.dismiss();
      return Failure(e);
    } on Exception {
      if (isLoader) EasyLoading.dismiss();
      return Failure(HttpException("Something went wrong..."));
    } catch (e) {
      if (isLoader) EasyLoading.dismiss();
      return Failure(HttpException("Something went wrong..."));
    }
  }

  Future<Result<dynamic, HttpException>> makePathRequest(
    UrlEndPoint endPoint,
    String path,
    BuildContext context, {
    bool isLoader = true,
  }) async {
    if (!(await Util().isNetworkConnected())) {
      return Failure(HttpException("No internet connection..."));
    }
    if (isLoader) {
      EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.clear,
      );
    }

    user = await Pref.getUserModelValue(PreferenceKey.userData.toString());

    setHeader();

    Uri url = Uri.parse(baseUrl + endPoint.stringValue + path);

    log('Url: $url');
    log('Headers: $headers');

    try {
      final response = await http.get(url, headers: headers);
      if (isLoader) {
        EasyLoading.dismiss();
      }
      switch (response.statusCode) {
        case 200:
          final decodedBody = utf8.decode(response.bodyBytes);
          final data = jsonDecode(decodedBody);
          //final data = jsonDecode(response.body);
          log('Response: $data');
          if (data["responseCode"] == null) {
            if (data["status"] == "success") {
              return Success(data);
            } else {
              return Failure(HttpException(data["responseMessage"]));
            }
          } else {
            switch (data["responseCode"]) {
              case >= 200 && < 399:
                return Success(data);
              default:
                return Failure(HttpException(data["responseMessage"]));
            }
          }
        case 401:
          log('logoutUser: ${response.statusCode}');
          // log('logoutUser: $response');
          logoutUser(context);
          return Failure(HttpException("Multiple Login"));
        default:
          // 3. return Failure with the desired exception
          return Failure(HttpException(response.reasonPhrase.toString()));
      }
    } on HttpException catch (e) {
      // 4. return Failure here too
      if (isLoader) {
        EasyLoading.dismiss();
      }
      return Failure(e);
    } on Exception catch (e) {
      if (isLoader) {
        EasyLoading.dismiss();
      }
      return Failure(HttpException(e.toString()));
    } catch (e) {
      if (isLoader) {
        EasyLoading.dismiss();
      }
      return Failure(HttpException(e.toString()));
    }
  }

  //Post Request
  //Multi part Post Request

  jsonToFormData(http.MultipartRequest request, Map<String, dynamic> data) {
    for (var key in data.keys) {
      request.fields[key] = data[key].toString();
    }
    return request;
  }

  jsonToFormHeaderData(
    http.MultipartRequest request,
    Map<String, dynamic> data,
  ) {
    for (var key in data.keys) {
      request.headers[key] = data[key].toString();
    }
    return request;
  }

  void logoutUser(BuildContext context) {
    Pref.removeValue(PreferenceKey.userData.toString());
    Pref.removeValue(PreferenceKey.isLogin.toString());
    Pref.removeValue(PreferenceKey.userDetail.toString());
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    // Navigator.restorablePopAndPushNamed(context, "/login");
  }
}
