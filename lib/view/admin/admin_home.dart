import 'package:flutter/material.dart';
import 'package:grocery_online_shop/controller/admin_provider.dart';
import 'package:grocery_online_shop/view/widgets/all_doctor_container.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';
import 'package:grocery_online_shop/view/widgets/textformfield_widget.dart';
import 'package:provider/provider.dart';
import 'package:enefty_icons/enefty_icons.dart';


const double circleAvatarRadiusFraction = 0.1;

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Provider.of<DoctorProvider>(context, listen: false).getAllDoctors();
    double circleAvatarRadius = size.shortestSide * circleAvatarRadiusFraction;
    final adminProvider = Provider.of<DoctorProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.blue[50], 
      appBar: AppBar(
          backgroundColor: const Color(0xFFF5F5F5),
          toolbarHeight: 100,
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * .02),
            child: CustomTextFormField(
              controller: adminProvider.searchController,
              hintText: 'Search',
              onChanged: (value) =>
                  adminProvider.search(adminProvider.searchController.text),
              prefixIcon: const Icon(
                EneftyIcons.search_normal_2_outline,
                color: Color(0xFFB2BAC6),
              ),
              suffixIcon: const Icon(
                EneftyIcons.firstline_outline,
                color: Color(0xFF1995AD),
              ),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Consumer<DoctorProvider>(
          builder: (context, doctorValue, child) {
            if (doctorValue.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (doctorValue.searchList.isEmpty &&
                doctorValue.searchController.text.isNotEmpty) {
              return Center(
                  child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Center(
                      child: poppinsHeadText(
                          text: 'NO DOCTOR FOUND..!',
                          color: const Color(0xFF1995AD),
                          fontSize: 20)),
                ),
              ));
            } else if (doctorValue.searchList.isEmpty) {
              if (doctorValue.allDoctorList.isNotEmpty) {
                final allDoctor = doctorValue.allDoctorList;

                return ListView.builder(
                  itemCount: allDoctor.length,
                  itemBuilder: (context, index) {
                    final doctors = allDoctor[index];
                    return Column(
                      children: [
                        AllDoctorsContainer(
                            size: size,
                            isAdmin: true,
                            doctors: doctors,
                            value: doctorValue,
                            circleAvatarRadius: circleAvatarRadius),
                        SizedBox(height: size.height * .02),
                      ],
                    );
                  },
                );
              } else {
                return Center(
                    child: poppinsHeadText(
                        text: "NO DOCTOR'S ADDED !",
                        color: const Color(0xFF1995AD),
                        fontSize: 20));
              }
            } else {
              return ListView.builder(
                itemCount: doctorValue.searchList.length,
                itemBuilder: (context, index) {
                  final doctor = doctorValue.searchList[index];
                  return Column(
                    children: [
                      AllDoctorsContainer(
                          size: size,
                          isAdmin: true,
                          doctors: doctor,
                          value: doctorValue,
                          circleAvatarRadius: circleAvatarRadius),
                      SizedBox(height: size.height * .02),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
