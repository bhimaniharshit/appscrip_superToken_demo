import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_token_demo/home_screen.dart';
import 'package:super_token_demo/utility.dart';
import 'package:supertokens_flutter/http.dart' as http;

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final String apiUrl =
      'https://suppertoken-api.juicy.network/auth/signIn'; // Replace with your API endpoint

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
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomeScreen(
            postId: data['user']['id'],
          ),
        ));
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign In',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 150),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your Email',
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true, // Hide the password
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your Password',
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 24.0),
              GestureDetector(
                onTap: _signIn,
                child: Container(
                  height: 55,
                  width: double.infinity, // Set width to full width
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      'Sign In'.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
