import 'dart:math';
import 'package:awesome_flutter/public/config/config.dart';
import 'package:awesome_flutter/public/index.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

final Http http = Http();

class Http extends BaseHttp {
  @override
  void init() {
    options.baseUrl = Config.baseUrl;
    interceptors..add(ApiInterceptor());
  }
}


class ApiInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    debugPrint('---api-request--->url--> ${options.baseUrl}${options.path}' +
        ' queryParameters: ${options.queryParameters}');
    // header中添加公共参数
    var nonce = Random().nextInt(1*10000000);
    var timestamp = DateTime.now().millisecondsSinceEpoch - DateTime(1970, 1,1,0,0,0,0).millisecondsSinceEpoch;
    options.headers["App-Key"] = Config.rongAppKey;
    options.headers["Nonce"] = nonce;
    options.headers["Timestamp"] = timestamp;
    var bytes = utf8.encode("ngVWD1wWoO$nonce$timestamp");
    options.headers["Signature"] = sha1.convert(bytes);
    return options;
  }

  @override
  onResponse(Response response) {
    ResponseData respData = ResponseData.fromJson(response.data);
    if (respData.success) {
      response.data = respData;
      return http.resolve(response);
    } else {
      // throw NotSuccessException.fromRespData(respData);
    }
  }
}

class ResponseData extends BaseResponseData {
  bool get success => 200 == code;

  ResponseData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['token'];
    data = json['userId'];
  }
}

