import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:super_token_demo/google_signin_api.dart';
import 'package:super_token_demo/home_screen.dart';
import 'package:super_token_demo/sign_in.dart';
import 'package:super_token_demo/utility.dart';
import 'package:supertokens_flutter/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _signUp() async {
    Utility.showLoadingDialog();

    final Map<String, dynamic> requestData = {
      'formFields': [
        {
          'id': 'userName',
          'value': userNameController.text,
        },
        {
          'id': 'email',
          'value': emailController.text,
        },
        {
          'id': 'password',
          'value': passwordController.text,
        },
      ]
    };

    final response = await http.post(
      Uri.parse('http://52.14.239.179:5007/auth/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      Utility.closeDialog();
      var data = json.decode(response.body);
      if (data['user'] != null) {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ));
      } else if (data['status'] == 'FIELD_ERROR') {
        Get.snackbar(
            'Error', json.decode(response.body)['formFields'][0]['error'],
            backgroundColor: Colors.red);
      } else {
        Get.snackbar('Error', json.decode(response.body)['status'],
            backgroundColor: Colors.red);
      }
      print('POST request successful');
      print('Response data: ${response.body}');
    } else {
      Utility.closeDialog();
      print('POST request failed with status: ${response.statusCode}');
      print('Response data: ${response.body}');
    }
  }

  Future<void> _googleSignUp(String accessToken, String idToken) async {
    Utility.showLoadingDialog();

    final Map<String, dynamic> requestData = {
      "thirdPartyId": "google",
      "clientType": "android",
      "oAuthTokens": {
        "access_token": accessToken,
        "id_token": idToken,
      }
    };

    final response = await http.post(
      Uri.parse('http://52.14.239.179:5007/auth/signinup'),
      headers: <String, String>{
        'rid': 'thirdparty',
        'Content-Type': 'application/json; charset=utf-8'
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      Utility.closeDialog();
      var data = json.decode(response.body);
      if (data['user'] != null) {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ));
      } else if (data['status'] == 'FIELD_ERROR') {
        Get.snackbar(
            'Error', json.decode(response.body)['formFields'][0]['error'],
            backgroundColor: Colors.red);
      } else {
        Get.snackbar('Error', json.decode(response.body)['status'],
            backgroundColor: Colors.red);
      }
      print('POST request successful');
      print('Response data: ${response.body}');
    } else {
      Utility.closeDialog();
      print('POST request failed with status: ${response.statusCode}');
      print('Response data: ${response.body}');
    }
  }

  /// Google Sign In
  ///
  Future googleSignIn() async {
    try {
      final user = await GoogleSignInApi.login();
      if (user == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Sign In failed.')));
      } else {
        var authentication = await user.authentication;
        String accessToken = authentication.accessToken ?? '';
        String idToken = authentication.idToken ?? '';
        _googleSignUp(accessToken, idToken);
      }
    } catch (e) {
      print('------->>>$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 100),
            TextField(
              controller: userNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your username',
                labelText: 'User Name',
              ),
            ),
            const SizedBox(height: 16.0),
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
              onTap: _signUp,
              child: Container(
                height: 55,
                width: double.infinity, // Set width to full width
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    'Sign Up'.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            GestureDetector(
              onTap: googleSignIn,
              child: Container(
                height: 55,
                width: double.infinity, // Set width to full width
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    'Sign Up with Google'.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()),
                    );
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
