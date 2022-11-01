import 'package:get/get.dart';
// import 'package:queue_service/models/attendants.dart';
// import 'package:queue_service/streams/blocs.dart';
import 'package:queue_service/utils/globals.dart';
import 'package:web_socket_channel/io.dart';

class Connection extends GetConnect {

  static IOWebSocketChannel channel = IOWebSocketChannel.connect(Uri.parse(websocketUrl));

  static addMessage(event) {
    channel.sink.add(event);
  }
}