import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_token_demo/utility.dart';
import 'package:supertokens_flutter/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final String apiUrl =
      'http://52.14.239.179:3001/auth/signIn'; // Replace with your API endpoint

  Future<void> _signIn() async {
    Utility.showLoadingDialog();
    String email = emailController.text;
    String password = passwordController.text;

    // You can add your login logic here
    // For a simple example, let's just print the values
    print('Email: $email');
    print('Password: $password');

    final Map<String, dynamic> requestData = {
      'formFields': [
        {
          'id': 'email',
          'value': email,
        },
        {
          'id': 'password',
          'value': password,
        },
      ]
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      Utility.closeDialog();
      var data = json.decode(response.body);
      if (data['user'] != null) {
      } else {
        Get.snackbar('Error', json.decode(response.body)['status'],
            backgroundColor: Colors.red);
      }
      print('POST request successful');
      print('Response data: ${response.body}');
      // Handle the response data as needed
    } else {
      Utility.closeDialog();
      print('POST request failed with status: ${response.statusCode}');
      print('Response data: ${response.body}');

      // Handle errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
