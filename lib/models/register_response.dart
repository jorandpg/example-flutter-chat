// To parse this JSON data, do
//
//     final registerResponse = registerResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/usuario_model.dart';

class RegisterResponse {
    bool ok;
    String msg;
    Usuario data;
    String token;

    RegisterResponse({
        required this.ok,
        required this.msg,
        required this.data,
        required this.token,
    });

    factory RegisterResponse.fromRawJson(String str) => RegisterResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
        ok: json["ok"],
        msg: json["msg"],
        data: Usuario.fromJson(json["data"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "data": data.toJson(),
        "token": token,
    };
}
