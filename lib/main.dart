import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:super_token_demo/sign_up.dart';
import 'package:supertokens_flutter/supertokens.dart';

void main() {
  SuperTokens.init(
    apiDomain: "http://52.14.239.179:5007",
    apiBasePath: "/auth",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.amber.shade800,
        colorScheme: const ColorScheme.light(
          primary: Colors.orange,
        ),
        useMaterial3: true,
      ),
      home: const SignUpScreen(),
    );
  }
}
