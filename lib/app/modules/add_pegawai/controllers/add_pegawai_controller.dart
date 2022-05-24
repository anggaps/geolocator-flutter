import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addPegawai() async {
    if (nameC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
                email: emailC.text, password: "password");

        if (userCredential.user != null) {
          String? uid = userCredential.user?.uid;
          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "email": emailC.text,
            "createdAt": DateTime.now().toIso8601String(),
          });

          await userCredential.user!.sendEmailVerification();
        }

        print(userCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar("terjadi kesalahan", "password terlalu lemah");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("terjadi kesalahan", "email sudah terpakai");
        }
      } catch (e) {
        Get.snackbar("terjadi kesalahan", "tidak bisa menambah pegawai");
      }
    } else {
      Get.snackbar("terjadi kesalahan", "NIP,nama dan email harus diisi");
    }
  }
}
