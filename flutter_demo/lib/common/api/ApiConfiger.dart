import '../interface/HandleNativeMessage.dart';

class ApiConfiger implements HandleNativeMessage {
  final String name;
  // _cache 变量是库私有的，因为在其名字前面有下划线。
  static final Map<String, ApiConfiger> _cache = <String, ApiConfiger>{};
  // 注意：在工厂构造函数中无法访问 this。
  factory ApiConfiger(String name) {
    return _cache.putIfAbsent(name, () => ApiConfiger._internal(name));
  }
  // 注意：在工厂构造函数中无法访问 this，所以需要另一个内部构造函数
  ApiConfiger._internal(this.name);

  Map<String, String> _api = {};

  get api => _api;

  @override
  void handleNativeMessage(message) {
    // TODO: implement handleNativeMessage
    if (message is List) {
      String type = message.first;
      Object object = message.last;
      if (type == 'api') {
        switch (this.name) {
          case 'zdjs':
            _handleZdjs(object);
            break;
          case 'xlmm':
            _handleXlmm(object);
            break;

          default:
            _handleZdjs(object);
            break;
        }
      }
    }
  }

  void _handleZdjs(dynamic message) {
    if (message is String) {
      // json 转成 Map 后合并
    } else if (message is Map) {
      // 直接合并 Map
    }
  }

  void _handleXlmm(dynamic message) {
    if (message is String) {
      // json 转成 Map 后合并
    } else if (message is Map) {
      // 直接合并 Map
    }
  }
}
