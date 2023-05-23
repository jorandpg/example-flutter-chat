import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/global/enviroment.dart';

enum ServerStatus {
  online,
  offline,
  connecting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.connecting;
  late Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  Socket get socket => _socket;

  SocketService() {
    _socket = io(Enviroment.socketUrl);
  }


  void connect() async {

    final token = await AuthService.getToken();

    _socket = io(
      Enviroment.socketUrl, 
      OptionBuilder()
        .setTransports(['websocket']) // for Flutter or Dart VM
        .enableAutoConnect()  // enabled auto-connection
        .enableForceNew()
        .setExtraHeaders({
          'x-token': token
        })
        .build()
    );
    
    _socket.onConnect( (_) {
       _socket.emit('mensaje', 'Conneted from Flutter App');
       _serverStatus = ServerStatus.online;
       notifyListeners();
    });
    _socket.onDisconnect( (_) {
      _serverStatus = ServerStatus.offline;
       notifyListeners();
    });

  }

  void disconnect() {
    _socket.disconnect();
  }

}