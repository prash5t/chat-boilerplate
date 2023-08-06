import 'dart:convert';
import 'dart:io';
import 'package:chatbot/core/constants/network_constants.dart';
import 'package:chatbot/core/constants/shared_prefs_constants.dart';
import 'package:chatbot/core/network/functions/get_header.dart';
import 'package:chatbot/core/utils/dialog_utils.dart';
import 'package:chatbot/core/utils/logger/debug_log.dart';
import 'package:chatbot/core/utils/service_locator.dart';
import 'package:chatbot/login/bloc/auth_bloc.dart';
import 'package:chatbot/login/data/repository/auth_repo.dart';
import 'package:chatbot/main_prod.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'base_client.dart';

class BaseClientImpl extends BaseClient {
  // getNewAccessToken method is used to repeast the network request when existing access token is expired
  Future<bool> getNewAccessToken() async {
    AuthRepo authRepo = locator<AuthRepo>();
    debugPrint("STATUS CODE 401, TRYING WITH NEW ACC TOKEN");
    final tokenResponse = await authRepo.requestForAccessToken();
    return tokenResponse.fold((l) async {
      // when new token is received, save new access token and we repeat the network request
      locator<SharedPreferences>()
          .setString(SharedPrefsKeys.accessToken, l.accessToken!);
      return true;
    }, (r) {
      return false;
    });
  }

  @override
  Future<Response<dynamic>?> getRequest({
    String baseUrl = "",
    Map<String, String>? optionalHeaders,
    Map<String, dynamic>? queryParameters,
    required String path,
    bool showDialog = false,
    bool shouldCache = true,
  }) async {
    Response? response;
    if (showDialog) showLoadingDialog();

    try {
      Map<String, String> header = getHeader();
      if (optionalHeaders != null) {
        header.addAll(optionalHeaders);
      }
      Dio dio = Dio();
      dio.interceptors.add(PrettyDioLogger(
        error: true,
        requestBody: true,
        requestHeader: true,
        request: false,
        responseBody: false,
      ));
      response = await dio.get(
        baseUrl + path,
        queryParameters: queryParameters,
        options: Options(
          headers: header,
          sendTimeout: const Duration(seconds: 40),
          receiveTimeout: const Duration(seconds: 40),
        ),
      );
      debugLog(baseUrl + path + response.statusCode.toString());
      if (shouldCache) {
        locator<SharedPreferences>().setString(
          path,
          jsonEncode(response.data).toString(),
        );
      }
    } on DioException catch (e, stackTrace) {
      if (e.response?.statusCode == 401) {
        if (e.response?.data[NetworkConstants.kKeyMessage] !=
            NetworkConstants.kKeyTokenExpired) {
          BlocProvider.of<AuthBloc>(navigatorKey.currentContext!)
              .add(LogoutClickedEvent());
        } else {
          if (await getNewAccessToken()) {
            response = await getRequest(
                baseUrl: baseUrl,
                optionalHeaders: optionalHeaders,
                queryParameters: queryParameters,
                path: path,
                showDialog: showDialog,
                shouldCache: shouldCache);
            return response;
          } else {
            BlocProvider.of<AuthBloc>(navigatorKey.currentContext!)
                .add(LogoutClickedEvent());
          }
        }
      } else if (e.response?.statusCode == 400) {
        return e.response;
      }
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugLog("DioException getreq error @path $path: $e");
      if (shouldCache && e.error is SocketException) {
        response = getCachedResponse(path);
      }
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugLog("Catch error: $e");
      if (shouldCache && e is SocketException) {
        response = getCachedResponse(path);
      }
    }
    if (showDialog) hideLoadingDialog();
    return response;
  }

  Response? getCachedResponse(String endpoint) {
    String? cachedResponse = locator<SharedPreferences>().getString(endpoint);
    Response? response = cachedResponse != null
        ? Response(
            requestOptions: RequestOptions(),
            data: cachedResponse,
            statusCode: 200,
          )
        : null;
    return response;
  }

  @override
  Future<Response?> postRequest({
    String baseUrl = "",
    Map<String, String>? optionalHeaders,
    Map<String, dynamic>? data,
    required String path,
    bool showDialog = false,
  }) async {
    Response? response;
    if (showDialog) {
      showLoadingDialog();
    }
    try {
      Map<String, String> header = getHeader();
      if (optionalHeaders != null) {
        header.addAll(optionalHeaders);
      }
      Dio dio = Dio();
      dio.interceptors.add(PrettyDioLogger(
        error: true,
        requestBody: true,
        requestHeader: true,
        request: false,
        responseBody: false,
      ));
      response = await dio.post(
        baseUrl + path,
        options: Options(
          headers: header,
          sendTimeout: const Duration(seconds: 40),
          receiveTimeout: const Duration(seconds: 40),
        ),
        data: data,
      );
      debugPrint("post req resp: $response");
    } on DioException catch (e, stackTrace) {
      if (e.response?.statusCode == 401) {
        if (e.response?.data[NetworkConstants.kKeyMessage] !=
            NetworkConstants.kKeyTokenExpired) {
          BlocProvider.of<AuthBloc>(navigatorKey.currentContext!)
              .add(LogoutClickedEvent());
        } else {
          if (await getNewAccessToken()) {
            response = await postRequest(
                baseUrl: baseUrl,
                optionalHeaders: optionalHeaders,
                data: data,
                path: path,
                showDialog: showDialog);
            return response;
          } else {
            BlocProvider.of<AuthBloc>(navigatorKey.currentContext!)
                .add(LogoutClickedEvent());
          }
        }
      }
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      try {
        debugLog("dio exp post req @path: $path : ${e.response}");
        response = e.response;
      } catch (e) {
        debugPrint("cannot get e.resp at postReq");
      }
      response = e.response;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugLog("catch post req: $e");
    }
    if (showDialog) hideLoadingDialog();
    return response;
  }

  @override
  Future<Response<dynamic>?> deleteRequest({
    String baseUrl = "",
    Map<String, String>? optionalHeaders,
    Map<String, dynamic>? data,
    required String path,
    bool showDialog = false,
  }) async {
    Response? response;
    if (showDialog) {
      showLoadingDialog();
    }
    try {
      Map<String, String> header = getHeader();
      if (optionalHeaders != null) {
        header.addAll(optionalHeaders);
      }
      Dio dio = Dio();
      dio.interceptors.add(PrettyDioLogger(
        error: true,
        requestBody: true,
        requestHeader: true,
        request: false,
        responseBody: false,
      ));
      response = await dio.delete(
        baseUrl + path,
        options: Options(
          headers: header,
          sendTimeout: const Duration(seconds: 40),
          receiveTimeout: const Duration(seconds: 40),
        ),
        data: data,
      );
      debugPrint("delete req resp: $response");
    } on DioException catch (e, stackTrace) {
      if (e.response?.statusCode == 401) {
        if (e.response?.data[NetworkConstants.kKeyMessage] !=
            NetworkConstants.kKeyTokenExpired) {
          BlocProvider.of<AuthBloc>(navigatorKey.currentContext!)
              .add(LogoutClickedEvent());
        } else {
          if (await getNewAccessToken()) {
            response = await deleteRequest(
                baseUrl: baseUrl,
                optionalHeaders: optionalHeaders,
                data: data,
                path: path,
                showDialog: showDialog);
            return response;
          } else {
            BlocProvider.of<AuthBloc>(navigatorKey.currentContext!)
                .add(LogoutClickedEvent());
          }
        }
      }
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      try {
        debugLog("dio exp delete req: ${e.response}");
        response = e.response;
      } catch (e) {
        debugPrint("cannot get e.resp at deleteReq");
      }
      response = e.response;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugLog("catch delete req: $e");
    }
    if (showDialog) hideLoadingDialog();
    return response;
  }
}
