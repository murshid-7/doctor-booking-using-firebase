import 'package:flutter/material.dart';
import 'package:grocery_online_shop/controller/admin_provider.dart';
import 'package:grocery_online_shop/model/doctor_model.dart';
import 'package:grocery_online_shop/view/widgets/all_doctor_container.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


const double circleAvatarRadiusFraction = 0.1;

class FavouriteDoctorsScreen extends StatelessWidget {
  const FavouriteDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double circleAvatarRadius = size.shortestSide * circleAvatarRadiusFraction;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 240, 242),
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          title: poppinsHeadText(text: 'Favourite', fontSize: 20),
          automaticallyImplyLeading: false,
          centerTitle: true),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child:
              Consumer<DoctorProvider>(builder: (context, doctorValue, child) {
            final favouriteItems = checkUser(doctorValue);
            if (favouriteItems.isEmpty) {
              return Center(
                  child: poppinsHeadText(
                      text: 'No Favourite Doctors Added !',
                      color: const Color(0xFF1995AD),
                      fontSize: 18));
            } else {
              return ListView.builder(
                itemCount: favouriteItems.length,
                itemBuilder: (context, index) {
                  final doctors = favouriteItems[index];
                  return Column(
                    children: [
                      AllDoctorsContainer(
                          size: size,
                          isAdmin: false,
                          doctors: doctors,
                          value: doctorValue,
                          circleAvatarRadius: circleAvatarRadius),
                      SizedBox(height: size.height * .02),
                    ],
                  );
                },
              );
            }
          })),
    );
  }

  List<DoctorModel> checkUser(DoctorProvider adminProvider) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return [];
    }
    final user = currentUser.email ?? currentUser.phoneNumber;
    List<DoctorModel> myDoctors = [];
    for (var car in adminProvider.allDoctorList) {
      if (car.wishList!.contains(user)) {
        myDoctors.add(car);
      }
    }
    return myDoctors;
  }
}
