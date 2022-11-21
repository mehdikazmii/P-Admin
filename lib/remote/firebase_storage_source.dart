import 'dart:io';
import 'package:betting_admin/remote/response.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageSource {
  FirebaseStorage instance = FirebaseStorage.instance;

  Future<Response<String>> uploadPrizeImage(
      {required String? filePath, required String? title}) async {
    String userPhotoPath = "prize_image/admin/$title";

    try {
      await instance.ref(userPhotoPath).putFile(File(filePath!));
      String downloadUrl = await instance.ref(userPhotoPath).getDownloadURL();
      return Response.success(downloadUrl);
    } catch (e) {
      return Response.error(((e as FirebaseException).message ?? e.toString()));
    }
  }
}
