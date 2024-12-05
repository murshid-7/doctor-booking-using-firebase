import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:grocery_online_shop/model/doctor_model.dart';
import 'package:grocery_online_shop/service/doctor_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorProvider extends ChangeNotifier {
  DoctorService doctorService = DoctorService();

  TextEditingController doctorNameController = TextEditingController();
  TextEditingController doctorAgeController = TextEditingController();
  TextEditingController doctorAboutController = TextEditingController();
  TextEditingController doctorAppointmentTimeController =
      TextEditingController();
  TextEditingController doctorAppointmentEndTimeController =
      TextEditingController();
  TextEditingController doctorPatientsController = TextEditingController();
  TextEditingController doctorExperienceController = TextEditingController();
  TextEditingController doctorRatingController = TextEditingController();

  final doctorAddFormkey = GlobalKey<FormState>();

  String? selectedGender;
  List<String> genders = ['Male', 'Female'];

  String? selectedCategory;
  List<String> category = [
    'General',
    'Dentist',
    'Otology',
    'Cardiology',
    'Intestine',
    'Pediatric',
    'Herbal',
  ];

  String? selectedPosition;
  List<String> position = [
    'Senior Surgeon',
    'Attending Physician',
    'Junior Surgeon',
    'Consultant',
    'Medical Officer'
  ];

  void clearDoctorAddingControllers() {
    doctorNameController.clear();
    doctorAgeController.clear();
    doctorAboutController.clear();
    doctorAppointmentTimeController.clear();
    doctorAppointmentEndTimeController.clear();
    doctorPatientsController.clear();
    doctorExperienceController.clear();
    doctorRatingController.clear();
    clearDoctorImage();
    clearDropdownValues();
  }

  void clearDoctorImage() {
    doctorImage = null;
    notifyListeners();
  }

  void clearDropdownValues() {
    selectedGender = null;
    selectedCategory = null;
    selectedPosition = null;

    notifyListeners();
  }

  File? doctorImage;
  String imageName = DateTime.now().microsecondsSinceEpoch.toString();
  String? downloadUrl;

  final ImagePicker imagePicker = ImagePicker();

  List<DoctorModel> allDoctorList = [];

  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> addDoctor(DoctorModel data) async {
    await doctorService.addDoctor(data);
    getAllDoctors();
    notifyListeners();
  }

  void deleteDoctor(String id, Function(String) onSuccess) async {
    await doctorService.deleteDoctor(id);
    onSuccess('doctor deleted');
    getAllDoctors();
  }

  void getAllDoctors() async {
    allDoctorList = await doctorService.getAllDoctors();

    notifyListeners();
  }

  Future<String> uploadImage(image, imageName) async {
    try {
      if (image != null) {
        String downloadUrl = await doctorService.uploadImage(imageName, image);
        log(downloadUrl);
        notifyListeners();
        return downloadUrl;
      } else {
        log('image is null');
        return '';
      }
    } catch (e) {
      log('got an error of $e');
      rethrow;
    }
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      doctorImage = File(pickedFile.path);
      log("Image picked");
      notifyListeners();
    }
  }

  TextEditingController searchController = TextEditingController();

  List<DoctorModel> searchList = [];

  void search(String value) {
    if (value.isEmpty) {
      searchList = [];
    } else {
      searchList = allDoctorList
          .where((DoctorModel doctor) =>
              doctor.fullName!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> wishlistClicked(String id, bool status) async {
    await doctorService.wishListClicked(id, status);
    notifyListeners();
  }

  bool wishListCheck(DoctorModel doctor) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final user = currentUser.email ?? currentUser.phoneNumber;
      if (doctor.wishList!.contains(user)) {
        getAllDoctors();
        return false;
      } else {
        getAllDoctors();
        return true;
      }
    } else {
      return true;
    }
  }

  Future<DoctorModel?> getDoctorById(String id) async {
    try {
      return await doctorService.getDoctorById(id);
    } catch (error) {
      log('Error fetching doctor by ID: $error');
      return null;
    }
  }
}
