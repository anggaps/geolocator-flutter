import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_pegawai_controller.dart';

class AddPegawaiView extends GetView<AddPegawaiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AddPegawaiView'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: controller.nipC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "nip",
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.nameC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Name",
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.emailC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "email",
              ),
            ),
            const SizedBox(height: 30),
            Obx(() => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    await controller.addPegawai();
                  }
                },
                child: Text(
                    controller.isLoading.isFalse ? "add pegawai" : "Loading")))
          ],
        ));
  }
}
