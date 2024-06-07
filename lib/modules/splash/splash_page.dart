import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taskapp/routes/route_management.dart';
import 'package:taskapp/utils/app_style.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      () => RouteManagement.goToHomePage(),
    );
    return Scaffold(
      body: Center(
        child: Text(
          "Hi",
          style: AppStyles.style10Normal
              .copyWith(fontSize: 35, color: Colors.blue.withOpacity(1.0)),
        ),
      ),
    );
  }
}
