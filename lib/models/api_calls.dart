import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_responses.dart';
import '../utils/globals.dart';
import 'app_controller.dart';

enum ApiMethods { get, post, put, patch, del }

class Api<T> {
  static Future<ApiRes<T>> request<T>(
      {required ApiMethods method,
      required String endpoint,
      int? timeout,
      Function? function,
      Object? body}) async {
    try {
      http.Response res;
      switch (method) {
        case ApiMethods.get:
          res = await Api.get(endpoint, timeout ?? 10);
          return ApiRes.parseData<T>(res.bodyBytes, parser: function);
        case ApiMethods.post:
          res = await Api.post(endpoint, timeout ?? 10,
              body: body);
          // if (endpoint == Endpoints.clientsAuth) {
          //   appCon.headers['Authorization'] = res.headers['Authorization'] ?? '';
          // }
          return ApiRes.parseData<T>(res.bodyBytes, parser: function);
        case ApiMethods.put:
          res = await Api.put(endpoint, timeout ?? 10,
              body: body);
          return ApiRes.parseData<T>(res.bodyBytes, parser: function);
        case ApiMethods.patch:
          res = await Api.patch(endpoint, timeout ?? 10,
              body: body);
          return ApiRes.parseData<T>(res.bodyBytes, parser: function);
        case ApiMethods.del:
          res = await Api.del(endpoint, timeout ?? 10,
              body: body);
          return ApiRes.parseData<T>(res.bodyBytes, parser: function);
      }
    } on http.ClientException {
      return ApiRes.connError();
    } on SocketException {
      return ApiRes.socketError();
    } on TimeoutException {
      return ApiRes.timeout();
    } catch (e) {
      debugPrint(e.toString());
      return ApiRes.unknow(err: e);
    }
  }

  static Future<http.Response> get(String endpoint, int time) async {
    return await http
        .get(Uri.parse('$requestUrl$endpoint'), headers: appCon.headers)
        .timeout(Duration(seconds: time));
  }

  static Future<http.Response> filterGet(
      String endpoint, dynamic body, int time) async {
    return await http
        .post(
          Uri.parse('$requestUrl$endpoint'),
          body: json.encode(body),
          headers: appCon.headers,
        )
        .timeout(Duration(seconds: time));
  }

  static Future<http.Response> post(String endpoint, int time,
      {dynamic body}) async {
    return await http
        .post(
          Uri.parse('$requestUrl$endpoint'),
          body: body != null ? json.encode(body) : null,
          headers: appCon.headers,
        )
        .timeout(Duration(seconds: time));
  }

  static Future<http.Response> put(String endpoint, int time,
      {dynamic body}) async {
    return await http
        .put(
          Uri.parse('$requestUrl$endpoint'),
          body: body != null ? json.encode(body) : null,
          headers: appCon.headers,
        )
        .timeout(Duration(seconds: time));
  }

  static Future<http.Response> del(String endpoint, int time,
      {dynamic body}) async {
    return await http
        .delete(
          Uri.parse('$requestUrl$endpoint'),
          body: body != null ? json.encode(body) : null,
          headers: appCon.headers,
        )
        .timeout(Duration(seconds: time));
  }

  static Future<http.Response> patch(String endpoint, int time,
      {dynamic body}) async {
    return await http
        .patch(
          Uri.parse('$requestUrl$endpoint'),
          body: body != null ? json.encode(body) : null,
          headers: appCon.headers,
        )
        .timeout(Duration(seconds: time));
  }
}