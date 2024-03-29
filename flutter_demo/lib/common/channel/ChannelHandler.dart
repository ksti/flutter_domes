import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class ChannelHandler with ChangeNotifier {
  ChannelHandler() {
    //实现通道的监听，并传入两个带有参数的函数用于监听到数据后 对数据进行处理
    //方案1(推荐)
    methodChannel..setMethodCallHandler(_handleMethodCall);
    //方案2
    eventChannel
        .receiveBroadcastStream()
        .listen(_receiveFromNative, onError: _fromNativeError);
  }

  //****************flutter调用原生方法，然后原生执行完毕后返值给flutter****************//

  dynamic nativeCallBackValue;

  //交互的通道名称，flutter和native是通过这个标识符进行相互间的通信
  static const methodChannel = MethodChannel('methodChannel_callMethods');

  //异步执行调用原生方法，保持页面不卡住，因为调用原生的方法可能没实现会抛出异常，所以trycatch包住
  Future<void> callNativeMethod(flutterPara) async {
    try {
      //原生方法名为callNativeMethond,flutterPara为flutter调用原生方法传入的参数，await等待方法执行
      final result =
          await methodChannel.invokeMethod('callNativeMethod', flutterPara);
      //如果原生方法执行回调传值给flutter，那下面的代码才会被执行
      nativeCallBackValue = result;
    } on PlatformException catch (e) {
      //抛出异常
      //flutter: PlatformException(001, 进入异常处理, 进入flutter的trycatch方法的catch方法)
      print('callNativeMethod error:$e');
    }
  }

  //****************原生主动调用flutter 方案1****************//
  //监听到数据后用于处理数据的方法，这个函数是用于处理接收到原生传进来的数据的，可自行定义
  Future<dynamic> _handleMethodCall(MethodCall methodCall) {
    var para = methodCall.arguments;
    print('receiveNativeCall para:$para');
    if ("callFlutterMethod" == methodCall.method) {
      nativeToFlutterValue = para;
      notifyListeners();
    }
    return Future.value(true);
  }

  //****************原生主动调用flutter 方案2****************//
  //存放原生传给flutter的值
  dynamic nativeToFlutterValue;

  //注册监听原生通道
  EventChannel eventChannel = EventChannel('eventChannel_receiveFromeNative');

  //监听到数据后用于处理数据的方法，这个函数是用于处理接收到原生传进来的数据的，可自行定义
  void _receiveFromNative(Object para) {
    print('receiveFromNative para:$para');
    nativeToFlutterValue = para;
    notifyListeners();
  }

  //原生返回错误信息
  void _fromNativeError(Object error) {
    print('fromNativeError error:$error');
  }
}
