import 'package:flutter/material.dart';
import 'package:maps/views/dashboard_page.dart';

class LoginController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login(BuildContext context) {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      // Simulação de login (poderia chamar Firebase/Auth API)
      if (email == "teste@email.com" && password == "123456") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login realizado com sucesso!")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email ou senha incorretos")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
    }
  }
}
