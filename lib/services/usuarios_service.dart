import 'package:http/http.dart' as http;

import 'package:chat/global/enviroment.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/models/usuario_model.dart';
import 'package:chat/models/usuarios_response.dart';

class UsuarioService {
  Future<List<Usuario>> getUsuarios() async {
    try {

      final uri = Uri.parse('${Enviroment.apiUrl}/usuarios');

      final response = await http.get(uri,
        headers: {
          'Content-type': 'application/json',
          'x-token': await AuthService.getToken()
        }
      );

      final usuariosResponse = UsuariosResponse.fromRawJson(response.body);

      return usuariosResponse.data;

    } catch (e) {
      return [];
    }
  }
}