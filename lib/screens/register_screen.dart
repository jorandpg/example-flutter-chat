import 'package:flutter/material.dart';

import 'package:chat/widgets/custom_button.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/custom_label.dart';
import 'package:chat/widgets/custom_logo.dart';

class RegisterScreen extends StatelessWidget {
   
  const RegisterScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                CustomLogo(titulo: 'Registro'),
                  
                _Form(),
                  
                CustonLabel(ruta: 'login', titulo: '¿Ya tienes una cuenta?', subtitulo: 'Ingresa ahora!'),
                  
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

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity_outlined,
            placeholder: 'Nombre',
            textController: nameController
          ),

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
            onPress: () {
              
            },
          )
          
        ],
      ),
    );
  }
}

