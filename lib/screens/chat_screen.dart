import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/models/mensajes_response.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';

class ChatScreen extends StatefulWidget {
   
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  late AuthService authService;
  late ChatService chatService;
  late SocketService socketService;

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isEscribiendo = false;
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    authService = Provider.of<AuthService>(context, listen: false);
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);

    // Escuchamos el mensaje personal (de quien nos escribe)
    socketService.socket.on('personal_message', _listeningMessage);

    _cargarHistorial(chatService.usuarioDestino.uid);

    super.initState();
  }

  @override
  void dispose() {
    // Off del socket
    socketService.socket.off('personal_message');

    for(ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final usuarioDestino = chatService.usuarioDestino;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: Text(usuarioDestino.nombre.substring(0,2), style: const TextStyle(fontSize: 12),),
            ),
            const SizedBox(height: 3,),
            Text(usuarioDestino.nombre, style: const TextStyle(color: Colors.black87, fontSize: 12),)
          ],
        ),
      ),

      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (context, index) => _messages[index],
                reverse: true,
              ),
            ),

            const Divider(height: 1,),

            /// Caja de texto
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],

        ),
      ),
      
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (value) {
                  setState(() {
                    _isEscribiendo = value.isNotEmpty;
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                focusNode: _focusNode,
              )
            ),

            // Botón Enviar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: !Platform.isIOS
                ? CupertinoButton(
                    onPressed: _isEscribiendo
                      ? () => _handleSubmit(_textController.text.trim())
                      : null, 
                    child: const Text('Enviar'), 
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: _isEscribiendo
                          ? () => _handleSubmit(_textController.text.trim())
                          : null, 
                        icon: const Icon(Icons.send)
                      ),
                    ),
                )
            )
          ],
        ),
      )
    );
  }

  // Función del boton enviar. Envía mensaje del chat al usuario destino
  _handleSubmit(String texto) {

    if(texto.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      texto: texto, 
      uid: authService.usuario.uid, 
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200)
      ),
    );
    
    _messages.insert(0, newMessage);

    newMessage.animationController.forward();


    setState(() {
      _isEscribiendo = false;
    });

    // Emitimos el mensaje personal al usuario destino
    socketService.socket.emit('personal_message', {
      'from': authService.usuario.uid,
      'to': chatService.usuarioDestino.uid,
      'message': texto
    });
  }

  void _listeningMessage( dynamic payload ){
    ChatMessage message = ChatMessage(
      texto: payload['message'], 
      uid: payload['de'] ?? '', 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
    );
    
    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }
  
  void _cargarHistorial(String usuarioId) async {
    List<Mensaje> chat = await chatService.getChat(usuarioId);

    final history = chat.map((m) => ChatMessage(
      texto: m.message, 
      uid: m.from, 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 0))..forward()
    ));

    setState(() {
      _messages.insertAll(0, history);
    });

  }
  
}