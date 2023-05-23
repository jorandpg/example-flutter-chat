// To parse this JSON data, do
//
//     final mensajesResponse = mensajesResponseFromJson(jsonString);

import 'dart:convert';

class MensajesResponse {
    bool ok;
    List<Mensaje> mensajes;

    MensajesResponse({
        required this.ok,
        required this.mensajes,
    });

    factory MensajesResponse.fromRawJson(String str) => MensajesResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MensajesResponse.fromJson(Map<String, dynamic> json) => MensajesResponse(
        ok: json["ok"],
        mensajes: List<Mensaje>.from(json["mensajes"].map((x) => Mensaje.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "mensajes": List<dynamic>.from(mensajes.map((x) => x.toJson())),
    };
}

class Mensaje {
    String to;
    String message;
    DateTime createdAt;
    DateTime updatedAt;
    String from;

    Mensaje({
        required this.to,
        required this.message,
        required this.createdAt,
        required this.updatedAt,
        required this.from,
    });

    factory Mensaje.fromRawJson(String str) => Mensaje.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        to: json["to"],
        message: json["message"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        from: json["from"],
    );

    Map<String, dynamic> toJson() => {
        "to": to,
        "message": message,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "from": from,
    };
}
