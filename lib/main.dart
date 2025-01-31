import 'package:flutter/material.dart';
import 'package:maps/database/database_helper.dart';
import 'models/user_model.dart';
import 'views/login_view.dart';
import 'views/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(),
      // home: DashboardPage(),
    );
  }
}
