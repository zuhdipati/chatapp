import 'package:chatapp/app/bindings/main_binding.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Chat App",
      initialRoute: Routes.splash,  
      getPages: AppPages.routes,
      initialBinding: MainBinding(),
    );
  }
}
