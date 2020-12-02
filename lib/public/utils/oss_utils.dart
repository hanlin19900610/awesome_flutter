import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

class OssUtils {
  final OssConfig config;
  Dio dio;

  OssUtils(this.config) {
    dio = Dio(BaseOptions(
      contentType: Headers.formUrlEncodedContentType,
      responseType: ResponseType.json,
    ));
    // dio.interceptors
    dio.options.responseType = ResponseType.plain;
    dio.options.contentType =
        ContentType.parse("multipart/form-data").toString();
  }

  /// 上传多个文件到oss 待测试
  Future<List<String>> uploadFilesToOss(List<File> files) async {
    return await Future.wait(files.map((e) => uploadFileToOss(e)));
  }

  /// Oss上传图片
  Future<String> uploadFileToOss(
    File file, {
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    //验证文本域
    String policyText =
        '{"expiration": "2090-01-01T12:00:00.000Z","conditions": [["content-length-range", 0, 1048576000]]}';
    //进行utf8编码
    List<int> policyTextUtf8 = utf8.encode(policyText);
    //进行base64编码
    String policyBase64 = base64.encode(policyTextUtf8);
    //再次进行utf8编码
    List<int> policy = utf8.encode(policyBase64);
    String accesskey = config.accessKeySecret;
    //进行utf8 编码
    List<int> key = utf8.encode(accesskey);
    //通过hmac,使用sha1进行加密
    List<int> signaturePre = new Hmac(sha1, key).convert(policy).bytes;
    //最后一步，将上述所得进行base64 编码
    String signature = base64.encode(signaturePre);
    //上传到文件名
    String fileName =
        file.path.substring(file.path.lastIndexOf("/") + 1, file.path.length);
    //创建一个formdata，作为dio的参数
    FormData data = new FormData.fromMap({
      'Filename': fileName,
      'key': "images/" + fileName,
      'policy': policyBase64,
      'OSSAccessKeyId': config.accessKeyId,
      'success_action_status': '200', //让服务端返回200，不然，默认会返回204
      'signature': signature,
      'file': await MultipartFile.fromFile(file.path, filename: fileName)
    });
    try {
      Response response =
          await dio.post("https://${config.bucket}.${config.endpoint}/",
              data: data,
              onSendProgress: onSendProgress ??
                  (count, total) {
                    print('上传进度: $count/$total');
                  },
              onReceiveProgress: onReceiveProgress ??
                  (count, total) {
                    print('下载进度: $count/$total');
                  });
      if (response.statusCode == 200) {
        print(response.headers);
        print(response.data);
        print("https://${config.bucket}.${config.endpoint}/images/" + fileName);
        return "https://${config.bucket}.${config.endpoint}/images/" + fileName;
      }
      return null;
    } on DioError catch (e) {
      print(e.message);
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
      print(accesskey);
      return null;
    }
  }
}

class OssConfig {
  String accessKeyId;
  String accessKeySecret;
  String endpoint;
  String bucket;

  OssConfig(this.accessKeyId, this.accessKeySecret, this.endpoint, this.bucket);
}
