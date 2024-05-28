import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shopeaseadminpanel/auth-ui/signin-screen.dart';
import 'package:shopeaseadminpanel/utils/app-constant.dart';

class ForgotPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> forgotPasswordMethod(String userEmail) async {
    try {
      EasyLoading.show(status: "Please wait a moments");
      await _auth.sendPasswordResetEmail(email: userEmail);
      Get.snackbar(
          'Request Sent Successfully', 'Password reset link send to $userEmail',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstant.appSecondaryColor,
          colorText: AppConstant.appTextColor);

      EasyLoading.dismiss();
      Get.off(() => SignInScreen());
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('Error', '$e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstant.appSecondaryColor,
          colorText: AppConstant.appTextColor);
    }
  }
}
