import 'package:dicom_phone/util/api_endpoint.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class LoginController extends GetxController {
  late TextEditingController idController;
  late TextEditingController pwController;

  @override
  void onInit() {
    super.onInit();
    idController = TextEditingController();
    pwController = TextEditingController();
  }

  /// Login Check
  // Future<bool> checkLogin(String username, String password) async {
  //   String baseUrl = APiEndPoints.baseurl + APiEndPoints.apiEndPoints.login;

  //   // String requestUrl = "$baseUrl/?"
    
  // }

  @override
  void dispose() {
    idController.dispose();
    pwController.dispose();
    super.dispose();
  }
} // End
