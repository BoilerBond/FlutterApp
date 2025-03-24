import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/data/entity/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file;
    }
  }

  Future<Uint8List?> selectImage() async {
    XFile img = await ImageHelper().pickImage(ImageSource.gallery);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: img.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 50,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop your image',
            toolbarColor: const Color.fromARGB(255, 34, 122, 255),
            toolbarWidgetColor: Colors.white,
            cropStyle: CropStyle.circle
        ),
        IOSUiSettings(
            title: 'Crop your image',
            cropStyle: CropStyle.circle
        ),
      ],
    );
    if (croppedFile == null) return null; // User canceled cropping

    return await croppedFile.readAsBytes();
  }

  Future<String> uploadImage(Uint8List image) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not logged in");
      return "";
    }
    print("Uploading image for user ${user.uid}");

    // get firebase storage reference with user id
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("profile_pictures")
        .child("${user.uid}.jpg");

    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();

    final userObj = await AppUser.getById(user.uid);
    userObj.profilePictureURL = downloadUrl;
    userObj.save(id: user.uid, merge: true);
    return downloadUrl;
  }
}