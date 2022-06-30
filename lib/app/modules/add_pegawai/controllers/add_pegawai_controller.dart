import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadinAddPegawai = false.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddPegawai() async {
    isLoadinAddPegawai.value = true;
    if (passwordAdminC.text.isNotEmpty) {
      try {
        String emailAdmin = auth.currentUser!.email!;

        UserCredential userCredentialAdmin =
            await auth.signInWithEmailAndPassword(
                email: emailAdmin, password: passwordAdminC.text);

        UserCredential pegawaiCredential =
            await auth.createUserWithEmailAndPassword(
                email: emailC.text, password: "password");

        if (pegawaiCredential.user != null) {
          String? uid = pegawaiCredential.user?.uid;
          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "email": emailC.text,
            "createdAt": DateTime.now().toIso8601String(),
          });

          await pegawaiCredential.user!.sendEmailVerification();

          await auth.signOut();

          UserCredential userCredentialAdmin =
              await auth.signInWithEmailAndPassword(
                  email: emailAdmin, password: passwordAdminC.text);

          Get.back(); // tutup dialog
          Get.back(); // back to home
          Get.snackbar('berhasil', 'berhasil menambahkan pegawai');
          isLoadinAddPegawai.value = false;
        }

        print(pegawaiCredential);
      } on FirebaseAuthException catch (e) {
        isLoadinAddPegawai.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar("terjadi kesalahan", "password terlalu lemah");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("terjadi kesalahan", "email sudah terpakai");
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
              "terjadi kesalahan", "admin tidak dapat login ,password salah");
        } else {
          Get.snackbar("terjadi kesalahan", e.code);
        }
      } catch (e) {
        isLoadinAddPegawai.value = false;

        Get.snackbar("terjadi kesalahan", "tidak bisa menambah pegawai");
      }
    } else {
      isLoading.value = false;

      Get.snackbar("Terjadi kesalahan", "password wajib diisi");
    }
  }

  Future<void> addPegawai() async {
    if (nameC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
          title: 'validasi admin',
          content: Column(
            children: [
              const Text('masukan password yntuk validasi admin'),
              const SizedBox(height: 10),
              TextField(
                controller: passwordAdminC,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "password",
                  border: OutlineInputBorder(),
                ),
              )
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                isLoading.value = false;
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            Obx(() => ElevatedButton(
                  onPressed: () async {
                    if (isLoadinAddPegawai.isFalse) {
                      await prosesAddPegawai();
                    }

                    isLoading.value = false;
                  },
                  child: Text(isLoadinAddPegawai.isFalse ? 'ADD' : 'LOADING'),
                ))
          ]);
    } else {
      Get.snackbar("terjadi kesalahan", "NIP,nama dan email harus diisi");
    }
  }
}
