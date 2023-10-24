import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_token_demo/utility.dart';
import 'package:supertokens_flutter/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.postId});
  final String postId;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    _getUserDetails();
    super.initState();
  }

  Future<void> _getUserDetails() async {
    Utility.showLoadingDialog();

    final response = await http.get(
      Uri.parse(
          'https://suppertoken-api.juicy.network/post/details?postId=${widget.postId}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
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
    _getUserDetails();

    return Scaffold();
  }
}
