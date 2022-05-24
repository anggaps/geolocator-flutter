import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/app/routes/app_pages.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );
        print(credential);

        if (credential.user != null) {
          if (credential.user!.emailVerified == true) {
            if (passC.text == "password") {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
                title: "belum verivikasi",
                middleText:
                    "kamu belum melakukan vertivikasi akun,lakukan vertivikasi di email kamu",
                actions: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text("cancel"),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await credential.user!.sendEmailVerification();
                          Get.back();
                          Get.snackbar("berhasil", "silahkan chek email anda");
                        } catch (e) {
                          Get.snackbar("Terjadi kesalahan",
                              "tidak dapat mengirim email vertifikasi");
                        }
                      },
                      child: const Text("Kirim ulang"))
                ]);
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar(
              "Terjadi kesalahan", "The password provided is too weak.");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Terjadi kesalahan",
              "The account already exists for that email.");
        }
      } catch (e) {
        Get.snackbar("Terjadi kesalahan", "tidak bisa login");
      }
    } else {
      Get.snackbar("Terjadi kesalahan", "Email dan pass wajib diisi");
    }
  }
}
