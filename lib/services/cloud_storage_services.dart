import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  static CloudStorageService instance = CloudStorageService();
  Future<String> uploadFile(String uid, File image, String label) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("things")
        .child(uid)
        .child("${DateTime.now().toString()}" + label);
    StorageUploadTask uploadTask = storageReference.putFile(image);
    var _url = await (await uploadTask.onComplete).ref.getDownloadURL();
    String downloadURL = _url;
    return downloadURL;
  }

  Future<String> avatarURL(String uid, File image, String label) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("avatar").child(uid).child(label);
    StorageUploadTask uploadTask = storageReference.putFile(image);
    var _url = await (await uploadTask.onComplete).ref.getDownloadURL();
    String downloadURL = _url;
    return downloadURL;
  }
}
