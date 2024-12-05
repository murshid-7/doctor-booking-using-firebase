import 'dart:io';
import 'dart:developer';
import 'package:grocery_online_shop/model/appointment_model.dart';
import 'package:grocery_online_shop/model/doctor_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DoctorService {
  String doctors = 'doctor';
  late CollectionReference<DoctorModel> doctor;
  final ImagePicker imagePicker = ImagePicker();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Reference storage = FirebaseStorage.instance.ref();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  DoctorService() {
    doctor = firebaseFirestore.collection(doctors).withConverter<DoctorModel>(
        fromFirestore: (snapshot, options) {
      return DoctorModel.fromJson(snapshot.id, snapshot.data()!);
    }, toFirestore: (value, options) {
      return value.toJson();
    });
  }

  Future<void> addDoctor(DoctorModel data) async {
    try {
      await doctor.add(data);
    } catch (error) {
      log('error during adding doctor :$error');
    }
  }


  Future<void> deleteDoctor(String id) async {
    try {
      await doctor.doc(id).delete();
    } catch (error) {
      log('error during deleting doctor :$error');
    }
  }

  Future<List<DoctorModel>> getAllDoctors() async {
    final snapshot = await doctor.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> wishListClicked(String id, bool status) async {
    try {
      if (status == true) {
        await doctor.doc(id).update({
          'wishlist': FieldValue.arrayUnion([
            firebaseAuth.currentUser!.email ??
                firebaseAuth.currentUser!.phoneNumber
          ])
        });
      } else {
        await doctor.doc(id).update({
          'wishlist': FieldValue.arrayRemove([
            firebaseAuth.currentUser!.email ??
                firebaseAuth.currentUser!.phoneNumber
          ])
        });
      }
    } catch (e) {
      log('got a error of :$e');
    }
  }

  Future<String> uploadImage(imageName, imageFile) async {
    Reference imageFolder = storage.child('productImage');
    Reference? uploadImage = imageFolder.child('$imageName.jpg');

    await uploadImage.putFile(imageFile);
    String downloadURL = await uploadImage.getDownloadURL();
    log('Image successfully uploaded to Firebase Storage.');
    return downloadURL;
  }

  Future<File?> pickImage(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<DoctorModel?> getDoctorById(String id) async {
    try {
      final docSnapshot = await doctor.doc(id).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
    } catch (error) {
      log('Error fetching doctor by ID: $error');
    }
    return null;
  }
}
