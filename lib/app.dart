import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'screens/login_page.dart';

class NexoraPlay extends StatelessWidget {
  const NexoraPlay({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEXORA PLAY',
      debugShowCheckedModeBanner: false,
      theme: AppColors.darkTheme(),
      home: const LoginPage(),
    );
  }
}