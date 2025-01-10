import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:task_flutter/controller/auth.dart';
import 'package:task_flutter/views/signup.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.emailController.value,
              decoration: InputDecoration(
                  label: const Text('Username'),
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            TextField(
              controller: controller.passController.value,
              decoration: InputDecoration(
                  label: const Text('Password'),
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(
              height: height * 0.07,
            ),
            SizedBox(
              width: width * 0.8,
              height: height * 0.07,
              child: ElevatedButton(
                  onPressed: () {
                    controller.login(
                        controller.emailController.value.text.toString(),
                        controller.passController.value.text.toString());
                  },
                  child: const Text('Login')),
            ),
            SizedBox(
              height: height * 0.07,
            ),
            OutlinedButton(
                onPressed: () => Get.to(() => const SignupScreen()),
                child: const Text('Go to Signup'))
          ],
        ),
      ),
    );
  }
}