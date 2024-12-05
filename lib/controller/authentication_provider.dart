import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:grocery_online_shop/model/authentication_model.dart';
import 'package:grocery_online_shop/service/authentication_service.dart';
import 'package:grocery_online_shop/view/widgets/admin_bottom_bar.dart';
import 'package:grocery_online_shop/view/widgets/snackbar_widget.dart';
import 'package:grocery_online_shop/view/widgets/user_bottom_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_picker/country_picker.dart';

class AuthenticationProvider extends ChangeNotifier {
  TextEditingController createAccountUserNameController =
      TextEditingController();
  TextEditingController createAccountEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController signInEmailController = TextEditingController();
  TextEditingController signInPasswordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  final otpFormkey = GlobalKey<FormState>();
  final phoneFormkey = GlobalKey<FormState>();
  final signInFormkey = GlobalKey<FormState>();
  final doctorAddFormKey = GlobalKey<FormState>();
  final fillAccountFormkey = GlobalKey<FormState>();
  final createAccountFormkey = GlobalKey<FormState>();
  final forgotPasswordFormkey = GlobalKey<FormState>();

  final AuthenticationService authenticationService = AuthenticationService();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  UserModel? currentUser;
  UserModel? sortedUser;

  Country selectCountry = Country(
      phoneCode: '91',
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "INDIA",
      example: "INDIA",
      displayName: "INDIA",
      displayNameNoCountryCode: "IN",
      e164Key: "");

  void notifyCountryChanged() {
    notifyListeners();
  }

  bool showOtpField = false;

  void showOtpFieldTrue() {
    showOtpField = true;
    notifyListeners();
  }

  String? selectedGender;
  List<String> genders = ['Male', 'Female'];

  bool signInObscureText = true;
  void signInObscureChange() {
    signInObscureText = !signInObscureText;
    notifyListeners();
  }

  bool createAccountObscureText = true;
  void createAccountObscureChange() {
    createAccountObscureText = !createAccountObscureText;
    notifyListeners();
  }

  bool createAccountConfirmObscureText = true;
  void createAccountConfirmObscureChange() {
    createAccountConfirmObscureText = !createAccountConfirmObscureText;
    notifyListeners();
  }

  adminKey(context, SnackBarWidget snackBarWidget, {String? message}) async {
    try {
      if (signInEmailController.text == 'admin@gmail.com' &&
          signInPasswordController.text == '12345') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminBottomBar()),
            (route) => false);
        clearSignInControllers();
      } else {
        await emailSignIn(
            signInEmailController.text, signInPasswordController.text);
        await getUser();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const UserBottomBar()),
            (route) => false);
        clearSignInControllers();
      }
    } catch (error) {
      snackBarWidget.showErrorSnackbar(context, message!);
    }
  }

  // void deniedAdminKey() {
  //   createAccountEmailController.text == 'admin';
  // }

  void clearSignInControllers() {
    signInEmailController.clear();
    signInPasswordController.clear();
  }

  void clearCreateAccountControllers() {
    createAccountUserNameController.clear();
    createAccountEmailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void clearFillProfileControllers() {
    createAccountEmailController.clear();
    profileImage = null;
  }

  void clearPhoneVerificationController() {
    phoneController.clear();
    otpController.clear();
  }

  Future<UserCredential> accountCreate(String email, String password) async {
    return await authenticationService.userEmailCreate(email, password);
  }

  Future<UserCredential> emailSignIn(String email, String password) async {
    return await authenticationService.userEmailSignIn(email, password);
  }

  Future<void> logOut() async {
    await authenticationService.logOut();
    currentUser = null;
    notifyListeners();
  }

  void googleSignIn(context) async {
    try {
      final user = await authenticationService.googleSignIn();
      if (user != null) {
        await authenticationService.addUser(user);
        currentUser = user;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const UserBottomBar(),
          ),
          (route) => false,
        );
        notifyListeners();
      } else {
        throw Exception('User is null');
      }
    } catch (e) {
      log('Sign up with Google error: $e');
    }
  }

  Future<void> googleSignOut() async {
    await authenticationService.googleSignOut();
    currentUser = null;
    notifyListeners();
  }

  Future<void> getOtp(phoneNumber) async {
    await authenticationService.getOtp(phoneNumber);
    notifyListeners();
  }

  Future<void> verifyOtp(otp, context, {error}) async {
    await authenticationService.verifyOtp(otp, context, error);
    notifyListeners();
  }

  Future<void> forgotPassword(context,
      {email,
      required Function(String) onError,
      required Function(String) success}) async {
    authenticationService.passwordReset(
        email: email, context: context, onError: onError, success: success);
  }

  addUser() async {
    final user = UserModel(
      email: createAccountEmailController.text,
      userName: createAccountUserNameController.text,
      uId: firebaseAuth.currentUser!.uid,
    );
    await authenticationService.addUser(user);
    getUser();
  }

  getUser() async {
    currentUser = await authenticationService.getCurrentUser();
    notifyListeners();
  }

  updateUser(userid, UserModel data) async {
    await authenticationService.updateUser(userid, data);
    clearFillProfileControllers();
    notifyListeners();
  }

  getDoctorUser(String uId) async {
    List<UserModel> allUsers = await authenticationService.getAllUser();
    sortedUser = allUsers.firstWhere((element) => element.uId == uId);
    notifyListeners();
  }

  File? profileImage;

  String imageName = DateTime.now().microsecondsSinceEpoch.toString();

  final ImagePicker imagePicker = ImagePicker();

  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      log("Image picked");
      notifyListeners();
    }
  }

  Future<String> uploadImage(image, imageName) async {
    try {
      if (image != null) {
        String downloadUrl =
            await authenticationService.uploadImage(imageName, image);
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

  Future<List<UserModel>> getAllUsers() async {
    try {
      List<UserModel> users = await authenticationService.getAllUser();
      return users;
    } catch (e) {
      log('Error fetching all users in AuthenticationProvider: $e');
      throw Exception('Failed to fetch users: $e');
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      UserModel? user = await authenticationService.getUserById(userId);
      return user;
    } catch (e) {
      log('Error fetching user by ID in AuthenticationProvider: $e');
      return null;
    }
  }
}
