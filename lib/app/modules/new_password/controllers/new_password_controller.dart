import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/app/routes/app_pages.dart';
import 'package:get/get.dart';

class NewPasswordController extends GetxController {
  TextEditingController newpassC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newpassC.text.isNotEmpty) {
      if (newpassC.text != "password") {
        try {
          await auth.currentUser!.updatePassword(newpassC.text);

          String? email = auth.currentUser!.email!;
          await auth.signOut();

          await auth.signInWithEmailAndPassword(
            email: email,
            password: newpassC.text,
          );

          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar("Terjadi kesalahan",
                "The password provided is too weak.setidaknya 6 karakter");
          }
        } catch (e) {
          Get.snackbar("Terjadi kesalahan",
              "tidak bisa ubah password,silahkan hubungi adminN");
        }
      } else {
        Get.snackbar("Terjadi kesalahan", "Password baru wajib diubah ");
      }
    } else {
      Get.snackbar("Terjadi kesalahan", "Password baru wajib diisi");
    }
  }
}
