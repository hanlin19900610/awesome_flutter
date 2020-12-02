import 'dart:io';
import 'package:awesome_flutter/public/config/config.dart';
import 'package:awesome_flutter/public/config/router_manager.dart';
import 'package:awesome_flutter/ui/page/home_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart' as prefix;
import 'package:awesome_flutter/public/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;
import 'common/event_bus.dart';

void main() async{
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.init();
  /// 强制竖屏, 因为设置竖屏为 `Future` 方法，防止设置无效可等返回值后再启动 App
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
      .then((value) {
    runApp(MyApp());
    if (Platform.isAndroid) {
      // Android状态栏透明 splash为白色, 所以调整状态栏文字为黑色
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light));
    }
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

  String pageName = "awesome_flutter.main";
  AppLifecycleState currentState = AppLifecycleState.resumed;
  DateTime notificationQuietEndTime;
  DateTime notificationQuietStartTime;
  static BuildContext appContext;

  static BuildContext getContext() {
    return appContext;
  }

  @override
  void initState() {
    super.initState();
    //1.初始化 im SDK
    prefix.RongIMClient.init(Config.rongAppKey);
    WidgetsBinding.instance.addObserver(this);
    EventBus.instance.addListener(EventKeys.UpdateNotificationQuietStatus,
            (map) {
          _getNotificationQuietHours();
        });

    /// 收到消息的回调
    prefix.RongIMClient.onMessageReceivedWrapper =
        (prefix.Message msg, int left, bool hasPackage, bool offline) {
      String hasP = hasPackage ? "true" : "false";
      String off = offline ? "true" : "false";
      if (msg.content != null) {
        developer.log(
            "object onMessageReceivedWrapper objName:" +
                msg.content.getObjectName() +
                " msgContent:" +
                msg.content.encode() +
                " left:" +
                left.toString() +
                " hasPackage:" +
                hasP +
                " offline:" +
                off,
            name: pageName);
      } else {
        developer.log(
            "object onMessageReceivedWrapper objName: ${msg.objectName} content is null left:${left.toString()} hasPackage:$hasP offline:$off",
            name: pageName);
      }
      if (currentState == AppLifecycleState.paused &&
          !checkNoficationQuietStatus()) {
        EventBus.instance.commit(EventKeys.ReceiveMessage,
            {"message": msg, "left": left, "hasPackage": hasPackage});
        prefix.RongIMClient.getConversationNotificationStatus(
            msg.conversationType, msg.targetId, (int status, int code) {
          if (status == 1) {
            _postLocalNotification(msg, left);
          }
        });
      } else {
        //通知其他页面收到消息
        EventBus.instance.commit(EventKeys.ReceiveMessage,
            {"message": msg, "left": left, "hasPackage": hasPackage});
      }
    };

    /// 收到原生数据的回调
    prefix.RongIMClient.onDataReceived = (Map map) {
      developer.log("object onDataReceived " + map.toString(), name: pageName);
    };

    /// 请求消息已读回执
    prefix.RongIMClient.onMessageReceiptRequest = (Map map) {
      EventBus.instance.commit(EventKeys.ReceiveReceiptRequest, map);
      developer.log("object onMessageReceiptRequest " + map.toString(), name: pageName);
    };

    /// 消息已读回执响应
    prefix.RongIMClient.onMessageReceiptResponse = (Map map) {
      EventBus.instance.commit(EventKeys.ReceiveReceiptResponse, map);
      developer.log("object onMessageReceiptResponse " + map.toString(), name: pageName);
    };

    /// 收到已读消息回执
    prefix.RongIMClient.onReceiveReadReceipt = (Map map) {
      EventBus.instance.commit(EventKeys.ReceiveReadReceipt, map);
      developer.log("object onReceiveReadReceipt " + map.toString(), name: pageName);
    };

  }

  void _getNotificationQuietHours() {
    prefix.RongIMClient.getNotificationQuietHours(
            (int code, String startTime, int spansMin) {
          if (startTime != null && startTime.length > 0 && spansMin > 0) {
            DateTime now = DateTime.now();
            String nowString = now.year.toString() +
                "-" +
                now.month.toString().padLeft(2, '0') +
                "-" +
                now.day.toString().padLeft(2, '0') +
                " " +
                startTime;
            DateTime start = DateTime.parse(nowString);
            notificationQuietStartTime = start;
            notificationQuietEndTime = start.add(Duration(minutes: spansMin));
          } else {
            notificationQuietStartTime = null;
            notificationQuietEndTime = null;
          }
        });
  }

  bool checkNoficationQuietStatus() {
    bool isNotificationQuiet = false;

    DateTime now = DateTime.now();
    if (notificationQuietStartTime != null &&
        notificationQuietEndTime != null &&
        now.isAfter(notificationQuietStartTime) &&
        now.isBefore(notificationQuietEndTime)) {
      isNotificationQuiet = true;
    }

    return isNotificationQuiet;
  }

  void _postLocalNotification(prefix.Message msg, int left) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = new AndroidInitializationSettings(
        "app_icon"); // app_icon 所在目录为 res/drawable/
    var initializationSettingsIOS = new IOSInitializationSettings(
        requestAlertPermission: true, requestSoundPermission: true);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: '本地通知');

    var platformChannelSpecifics =
    NotificationDetails(androidPlatformChannelSpecifics, null);

    String content = "测试本地通知";

    await flutterLocalNotificationsPlugin.show(
        0, 'RongCloud IM', content, platformChannelSpecifics,
        payload: 'item x');
  }


  @override
  Widget build(BuildContext context) {
    appContext = context;
    return OKToast(
      child: RefreshConfiguration(
        // 列表数据不满一页, 不触发加载更多
        hideFooterWhenNotFull: false,
        headerBuilder: () => ClassicHeader(),
        footerBuilder: () => ClassicFooter(),
        autoLoad: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.white,
          ),
          darkTheme: ThemeData(brightness: Brightness.dark),
          locale: Locale('zh', 'CN'),
          localizationsDelegates: const [
            RefreshLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const <Locale>[
            Locale.fromSubtags(languageCode: 'zh'),
          ],
          navigatorKey: navigatorKey,
          home: HomePage(),
        ),
      ),
    );
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    developer.log("--" + state.toString(), name: pageName);
    currentState = state;
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        break;
      case AppLifecycleState.detached: // 申请将暂时暂停
        break;
    }
  }

}