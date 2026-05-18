import 'package:flutter/material.dart';
import 'injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Dependency Injection
  await di.init();
  
  runApp(const ArchAcademyApp());
}

class ArchAcademyApp extends StatelessWidget {
  const ArchAcademyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Arch Academy',
      debugShowCheckedModeBanner: false,
      
      // Theme settings
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Adapts to system settings
      
      // Routing settings
      routerConfig: AppRouter.router,
    );
  }
}
