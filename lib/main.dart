import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/bindings/app_bindings.dart';
import 'features/dashboard/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ChurchMS App',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBindings(),
      home: const HomePage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
