import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class FileController extends GetxController {
  var selectedImage = ''.obs;
  var location = ''.obs;
  var isLoading = false.obs;
  final String uploadUrl = '/upload';

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

  Future<void> uploadImage(String token) async {
    isLoading.value = true;

    try {
      final fileName = selectedImage.value.split('/').last;

      final formData = dio.FormData.fromMap({
        'image': await dio.MultipartFile.fromFile(selectedImage.value,
            filename: fileName, contentType: MediaType('image', 'jpeg')),
      });
      print(token);
      print(formData.toString());

      debugPrint('File path: ${selectedImage.value}');
      debugPrint('File name: $fileName');
      debugPrint('FormData Files: ${formData.files}');
      debugPrint('FormData Fields: ${formData.fields}');

      final response = await dio.Dio().post(
        'https://interview-mock-api.onrender.com/upload',
        data: formData,
        options: dio.Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => true,
        ),
      );
      print(response.data);

      dio.Dio dioInstance = dio.Dio();
      dioInstance.interceptors.add(dio.LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
      ));

      if (response.statusCode == 201) {
        //imageUrl.value = response.data['upload']['storedFilename'];
        Get.snackbar('Success', 'Image uploaded successfully.');
      } else {
        Get.snackbar('Error', 'Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: ${e.toString()}');
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchImage(String token) async {
    try {
      dio.Response response = await dio.Dio().get(
        'https://interview-mock-api.onrender.com/uploads',
        options: dio.Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => true,
        ),
      );
      debugPrint(response.statusCode.toString());

      if (response.statusCode == 200) {
        print(response.data['uploads']);
        return response.data;
      } else {
        throw Exception('Failed to fetch image.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong while fetching the image.');
      throw Exception('Failed to fetch image: $e');
    }
  }
}
