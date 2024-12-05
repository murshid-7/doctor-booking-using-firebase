import 'package:flutter/material.dart';
import 'package:grocery_online_shop/view/admin/admin_add_doctor.dart';
import 'package:grocery_online_shop/view/admin/admin_home.dart';
import 'package:grocery_online_shop/view/admin/admin_profile.dart';
import 'package:grocery_online_shop/view/admin/bookings_data.dart';
import 'package:grocery_online_shop/view/user/appointment/appointment_tab.dart';
import 'package:grocery_online_shop/view/user/doctors/all_doctors.dart';
import 'package:grocery_online_shop/view/user/home/user_home.dart';
import 'package:grocery_online_shop/view/user/profile/profile_user.dart';

class BottomProvider extends ChangeNotifier {
  int userCurrentIndex = 0;
  int adminCurrentIndex = 0;

  void userOnTap(int index) {
    userCurrentIndex = index;
    notifyListeners();
  }

  void adminOnTap(int index) {
    adminCurrentIndex = index;
    notifyListeners();
  }

  List userScreens = [
    const UserHomeScreen(),
    const AppointmentScreen(),
    const AllDoctorsScreen(),
    const UserProfileScreen()
  ];

  List adminScreens = [
    const AdminHomeScreen(),
    const DoctorAddingScreen(),
    const AdminProfileScreen(),
     SummaryScreen(),
  ];
}
