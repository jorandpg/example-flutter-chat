import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat/models/usuario_model.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/register_response.dart';
import 'package:chat/global/enviroment.dart';

class AuthService with ChangeNotifier {
  late Usuario usuario;
  bool _isAutenticando = false;
  bool _isRegistrando = false;

  // Create storage
  final _storage = const FlutterSecureStorage();

  bool get isAutenticando => _isAutenticando;
  set isAutenticando(bool value) {
    _isAutenticando = value;
    notifyListeners();
  }

  bool get isRegistrando => _isRegistrando;
  set isRegistrando(bool value) {
    _isRegistrando = value;
    notifyListeners();
  }

  // Getter del token de forma statica
  static Future<String> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token!;
  }
  
  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  /// Función para realizar la autenticación
  Future<bool> login(String email, String password) async {
    isAutenticando = true;

    final data = {
      'email': email,
      'password': password
    };

    final uri = Uri.parse('${ Enviroment.apiUrl }/login');
    final response = await http.post( 
      uri,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      } 
    );

    isAutenticando = false;
    if(response.statusCode == 200) {
      final loginResponse = LoginResponse.fromRawJson(response.body);
      usuario = loginResponse.data;
      
      // Guardamos el token
      await _saveToken(loginResponse.token);

      return true;
    } else {
      return false;
    }

  }

  /// Función para registrar usuario
  Future<bool> register(String nombre, String email, String password) async {
    isRegistrando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password
    };

    final uri = Uri.parse('${ Enviroment.apiUrl }/login/new');

    final response = await http.post( 
      uri,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      } 
    );

    isRegistrando = false;
    if(response.statusCode == 200) {
      final registerResponse = RegisterResponse.fromRawJson(response.body);
      usuario = registerResponse.data;
      
      // Guardamos el token
      await _saveToken(registerResponse.token);

      return true;
    } else {
      return false;
    }

  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    if(token == null) {
      return false;
    }

    final uri = Uri.parse('${ Enviroment.apiUrl }/login/refresh');

    final response = await http.get( 
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token
      } 
    );

    if(response.statusCode == 200) {
      final loginResponse = LoginResponse.fromRawJson(response.body);
      usuario = loginResponse.data;
      
      // Guardamos el token
      await _saveToken(loginResponse.token);

      return true;
    } else {

      logout(token);
      return false;
    }    
  }

  Future _saveToken(String token) async {
    // Write token
    return await _storage.write(key: 'token', value: token);
  }

  Future logout(String token) async {
    // Delete token
    await _storage.delete(key: 'token');
  }

}