// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/usuario_model.dart';

class UsuariosResponse {
    bool ok;
    String msg;
    List<Usuario> data;

    UsuariosResponse({
        required this.ok,
        required this.msg,
        required this.data,
    });

    factory UsuariosResponse.fromRawJson(String str) => UsuariosResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UsuariosResponse.fromJson(Map<String, dynamic> json) => UsuariosResponse(
        ok: json["ok"],
        msg: json["msg"],
        data: List<Usuario>.from(json["data"].map((x) => Usuario.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}
