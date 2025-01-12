import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flutter/views/dashboard.dart';
import '../views/login.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController().obs;
  final passController = TextEditingController().obs;
  var apiUrl = 'https://interview-mock-api.onrender.com';
  RxString tknValue = "".obs;

  Future<void> signup(String uName, String password) async {
    //var dio = Dio();

    var data = {
      'username': uName.toString().trim(),
      'password': password.toString().trim(),
    };
    try {
      dio.Response response = await dio.Dio().post(
          'https://interview-mock-api.onrender.com/signup',
          data: jsonEncode(data));

      if (response.statusCode == 201) {
        debugPrint('Signup successful');
        Get.to(() => const LoginScreen());
      }
    } catch (e) {
      debugPrint("Error : ${e.toString()}");
    }
  }

  Future<void> login(String uName, String password) async {
    var data = {
      'username': uName.toString().trim(),
      'password': password.toString().trim(),
    };
    try {
      dio.Response response = await dio.Dio().post(
          'https://interview-mock-api.onrender.com/login',
          data: jsonEncode(data));

      if (response.statusCode == 200) {
        debugPrint('Login successful');
        debugPrint(response.data['token']);
        tknValue.value = response.data['token'];
        Get.offAll(() => HomeScreen(tknValue: response.data['token']));
      }
    } catch (e) {
      debugPrint("Error : ${e.toString()}");
    }
  }
}
