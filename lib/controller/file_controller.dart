import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FileController extends GetxController {
  var selectedImage = ''.obs;
  var location = ''.obs;
  var isLoading = false.obs;
  final String uploadUrl = 'https://api.escuelajs.co/api/v1/files/upload';

  // Function to pick an image
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      selectedImage.value = pickedFile.path;
    } else {
      Get.snackbar('Error', 'No image selected.');
    }
  }

  Future<void> uploadImage() async {
    if (selectedImage.value.isEmpty) {
      Get.snackbar('Error', 'Please select an image first.');
      return;
    }

    isLoading.value = true;

    try {
      var fileName = selectedImage.value.split('/').last;

      dio.FormData formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(selectedImage.value,
            filename: fileName),
      });
      debugPrint(fileName);

      dio.Response response = await dio.Dio().post(uploadUrl, data: formData);

      if (response.statusCode == 201) {
        debugPrint(response.data['location']);
        location.value = response.data['location'];
        Get.snackbar('Success', 'Image uploaded successfully.');
      } else {
        Get.snackbar('Error', 'Failed to upload image.');
      }
    } catch (e) {
      debugPrint('Error : Something went wrong. => ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> fetchImage() async {
    try {
      dio.Response response = await dio.Dio().get(location.value);
      debugPrint(response.statusCode.toString());

      if (response.statusCode == 200) {
        return location.value;
      } else {
        throw Exception('Failed to fetch image.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong while fetching the image.');
      return '';
    }
  }
}
