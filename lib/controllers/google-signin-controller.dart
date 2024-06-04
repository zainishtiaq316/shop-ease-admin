import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';


import '../models/user-model.dart';
import '../screens/admin-main-screen.dart';
import 'getting-token.dart';

class GoogleSignInController extends GetxController {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
   DateTime currentTime = DateTime.now();

  Future<void> signInWithGoogle() async {
    final GetDeviceTokenController getDeviceTokenController =
        Get.put(GetDeviceTokenController());
         String formattedDateTime = DateFormat('dd/MM/yyyy - h:mma').format(currentTime);
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        EasyLoading.show(status: "Please wait a moment...");
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        final User? user = userCredential.user;

        if (user != null) {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            // User exists, check isAdmin status
            final userData = userDoc.data() as Map<String, dynamic>;
            final isAdmin = userData['isAdmin'] ?? false;
            EasyLoading.dismiss();
            if (isAdmin) {
             // User is not admin, show error message
              EasyLoading.showError("Error: Only users are allowed.");
              await _auth.signOut();
              await googleSignIn.signOut();
            } else {
              // User is not admin, navigate to main screen
              Get.offAll(() => AdminMainScreen());
            }
          } else {
            UserModel userModel = UserModel(
              lastName: '',
                city: '',
                          Gender: '',
                           language: 'English',
          dateOfBirth: '',
          updatedOn: DateTime.now(),
                country: '',
                createdOn: DateTime.now(),
                email: user.email.toString(),
                isAdmin: false,
                isActive: true,
                phone: user.phoneNumber.toString(),
                    joinedTime: formattedDateTime,
          updatedTime: formattedDateTime,
                street: '',
                uid: user.uid,
                userAddress: '',
                userDeviceToken:
                    getDeviceTokenController.deviceToken.toString(),
                userImg: user.photoURL.toString(),
                firstName: user.displayName.toString());

            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set(userModel.toMap());
            EasyLoading.dismiss();
            Get.offAll(() => AdminMainScreen());
          }
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("error $e");
    }
  }
}
