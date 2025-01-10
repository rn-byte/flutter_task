import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flutter/controller/file_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FileController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() {
                return controller.selectedImage.value.isNotEmpty
                    ? Image.file(File(controller.selectedImage.value),
                        height: 200)
                    : const Text('No image selected.');
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.pickImage,
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 20),
              Obx(() {
                return controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          await controller.uploadImage();
                        },
                        child: const Text('Upload Image'),
                      );
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  var imageUrl = await controller.fetchImage();
                  if (imageUrl.isNotEmpty) {
                    showDialog(
                      // ignore: use_build_context_synchronously
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Image.network(imageUrl),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('View Uploaded Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
