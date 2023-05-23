import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/screens/screens.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';

class LoadingScreen extends StatelessWidget {
   
  const LoadingScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        // Función para verificar si el usuario está logueado
        future: checkLoginState(context),   

        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final isAuth = await authService.isLoggedIn();

    if(isAuth) {
      // Conectar al socket server
      socketService.connect();

      // Navegamos al home
      if (context.mounted) {
        Navigator.pushReplacement(
          context, 
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 0),
            pageBuilder: (_, __, ___) => const UsuariosScreen(),
          )
        );
      }

    } else {
      // Desconectamos del socket server
      socketService.disconnect();

      // Navegamos al login
      if (context.mounted) {
        Navigator.pushReplacement(
          context, 
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 0),
            pageBuilder: (_, __, ___) => const LoginScreen(),
          )
        );
      }
    }
  }

}