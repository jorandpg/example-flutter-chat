import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final String titulo;
  final Color color;
  final Function()? onPress;

  const CustomButton({super.key, required this.titulo, required this.color, this.onPress});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: color,
        shape: const StadiumBorder()
      ),
      onPressed: onPress,
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 18),)
        )
      ),
    );
  }
}