import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat/widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
   
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isEscribiendo = false;
  List<ChatMessage> _messages = [];

  @override
  void dispose() {
    // TODO: off del socket

    for(ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: const Text('JP', style: TextStyle(fontSize: 12),),
            ),
            const SizedBox(height: 3,),
            const Text('Jorge Perez', style: TextStyle(color: Colors.black87, fontSize: 12),)
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

  _handleSubmit(String texto) {

    if(texto.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      texto: texto, 
      uid: '123', 
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
  }
  
}