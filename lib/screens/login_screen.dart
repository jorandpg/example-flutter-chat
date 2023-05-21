import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat/helpers/mostrar_alerta_login.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/widgets/custom_button.dart';
import 'package:chat/widgets/custom_label.dart';
import 'package:chat/widgets/custom_logo.dart';
import 'package:chat/widgets/custom_input.dart';

class LoginScreen extends StatelessWidget {
   
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomLogo(titulo: 'Messenger'),
                  
                _Form(),
                  
                CustonLabel(ruta: 'register', titulo: '¿No tienes cuenta?', subtitulo: 'Crea una ahora!'),
                  
                Text('Términos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo electrónico', 
            keyboardType: TextInputType.emailAddress, 
            textController: emailController
          ),

          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña', 
            textController: passwordController,
            isPassword: true,
          ),
          
          CustomButton(
            titulo: 'Ingrese', 
            color: Colors.blue,
            onPress: authService.isAutenticando ? null : () async {
              // Se quita el foco y/o teclado
              FocusScope.of(context).unfocus();

              // Enviamos datos para autenticación
              final isAuth = await authService.login(emailController.text.trim(), passwordController.text.trim());

              if(isAuth) {
                // TODO: Conectamos al socket server

                // Navegamos al home
                if (context.mounted) Navigator.pushReplacementNamed(context, 'usuarios');

              } else {
                // Mostramos alerta
                if (context.mounted) showAlert(context, 'Login Incorrecto', 'Revise sus credenciales');
              }

            },
          )
          
        ],
      ),
    );
  }
}

