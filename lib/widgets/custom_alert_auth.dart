import 'package:flutter/material.dart';

class CustomAlertAuth extends StatelessWidget {

  final String title;
  final String subtitle;

  const CustomAlertAuth({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  showAlert(BuildContext context, String title, String subtitle) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(subtitle),
        actions: [
          MaterialButton(
            elevation: 5,
            textColor: Colors.blue,
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }
}