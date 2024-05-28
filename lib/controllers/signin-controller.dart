import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shopeaseadminpanel/utils/app-constant.dart';

class SigninController extends GetxController{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //for password visibilty
  var isPasswordVisible = false.obs;

  Future<UserCredential?> signInMethod(String userEmail ,String userPassword  )async{
try{
EasyLoading.show(status: "Please wait a moments");
  UserCredential userCredential =await _auth.signInWithEmailAndPassword(email: userEmail, password: userPassword);



 
 
EasyLoading.dismiss();
return userCredential;


} on FirebaseAuthException catch(e){
EasyLoading.dismiss();
  Get.snackbar('Error', '$e', snackPosition: SnackPosition.BOTTOM , backgroundColor: AppConstant.appSecondaryColor, colorText: AppConstant.appTextColor);
}
  }
}