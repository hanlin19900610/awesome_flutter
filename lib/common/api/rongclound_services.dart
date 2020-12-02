
import 'package:awesome_flutter/common/api/rongclound_api.dart';
import 'package:dio/dio.dart';

class RongCloundServices {
  static Future<Response> getToken(String userId, String nickName) async {
    return await http.post("/user/getToken.json", data: {
      'userId': userId,
      'name': nickName,
      'portraitUri':
          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1598099154738&di=de2660f070687fd0b84c04302cc448ed&imgtype=0&src=http%3A%2F%2Fdp.gtimg.cn%2Fdiscuzpic%2F0%2Fdiscuz_x5_gamebbs_qq_com_forum_201306_19_1256219xc797y90heepdbh.jpg%2F0'
    });
  }
}
