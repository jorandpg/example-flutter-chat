import 'package:chat/models/mensajes_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat/services/auth_service.dart';
import 'package:chat/global/enviroment.dart';
import 'package:chat/models/usuario_model.dart';

class ChatService extends ChangeNotifier {
  late Usuario usuarioDestino;

  Future<List<Mensaje>> getChat(String usuarioId) async {
    final uri = Uri.parse('${Enviroment.apiUrl}/mensajes/$usuarioId');

    final response = await http.get(uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      }
    );

    final mensajesResponse = MensajesResponse.fromRawJson(response.body);

    return mensajesResponse.mensajes;
  }
}