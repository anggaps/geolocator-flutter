import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/app/routes/app_pages.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    isLoading.value = true;
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
            isLoading.value = false;
            if (passC.text == "password") {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            isLoading.value = false;
            Get.defaultDialog(
                title: "belum verivikasi",
                middleText:
                    "kamu belum melakukan vertivikasi akun,lakukan vertivikasi di email kamu",
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      isLoading.value = false;
                      Get.back();
                    },
                    child: const Text("cancel"),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await credential.user?.sendEmailVerification();
                          Get.back();
                          Get.snackbar("berhasil", "silahkan chek email anda");
                          isLoading.value = false;
                        } catch (e) {
                          isLoading.value = false;
                          Get.snackbar("Terjadi kesalahan",
                              "tidak dapat mengirim email vertifikasi");
                        }
                      },
                      child: const Text("Kirim ulang"))
                ]);
          }
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar("Terjadi kesalahan", "email yang dimasukan salah");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi kesalahan", "password salah ");
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Terjadi kesalahan", "tidak bisa login");
      }
    } else {
      Get.snackbar("Terjadi kesalahan", "Email dan pass wajib diisi");
    }
  }
}
