import 'dart:developer';
import 'package:grocery_online_shop/controller/admin_provider.dart';
import 'package:grocery_online_shop/controller/appointment_provider.dart';
import 'package:grocery_online_shop/controller/bottom_bar_provider.dart';
import 'package:grocery_online_shop/helper/loading_indicator.dart';
import 'package:grocery_online_shop/model/appointment_model.dart';
import 'package:grocery_online_shop/model/doctor_model.dart';
import 'package:grocery_online_shop/view/user/home/home_widgets.dart';
import 'package:grocery_online_shop/view/widgets/all_doctor_container.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double circleAvatarRadiusFraction = 0.091;
const double upcomingCircleAvatarRadiusFraction = 0.081;

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Provider.of<DoctorProvider>(context, listen: false).getAllDoctors();
    double circleAvatarRadius = size.shortestSide * circleAvatarRadiusFraction;
    double upcomingAvatarRadius =
        size.shortestSide * upcomingCircleAvatarRadiusFraction;
    final bottomProvider = Provider.of<BottomProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 238, 240, 242),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * .042, vertical: size.height * 0.01),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                homeAppBar(size, context),
                SizedBox(height: size.height * .02),
                Consumer<AppointmentProvider>(
                  builder: (context, appointmentProvider, child) {
                    final allAppointments =
                        appointmentProvider.allAppointmentList;
                    final upcomingAppointments = allAppointments
                        .where((appointment) =>
                            isUpcomingAppointment(appointment) &&
                            (appointment.status == null ||
                                appointment.status != 'canceled'))
                        .toList();
                    upcomingAppointments.sort((a, b) {
                      final aDateTime = parseDateTime(a.date!, a.time!);
                      final bDateTime = parseDateTime(b.date!, b.time!);
                      return aDateTime.compareTo(bDateTime);
                    });
                    if (upcomingAppointments.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.only(left: size.width * .01),
                        child: SizedBox(
                          height: size.height * .19,
                          width: size.width * .88,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              border: Border.all(
                                color: const Color(0xFFFFFFFF),
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Center(
                              child: poppinsHeadText(
                                text: 'No Upcoming Appointments',
                                color: Colors.blue,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      final nextUpcomingAppointment =
                          upcomingAppointments.first;
                      return FutureBuilder<DoctorModel?>(
                        future:
                            Provider.of<DoctorProvider>(context, listen: false)
                                .getDoctorById(nextUpcomingAppointment.docId!),
                        builder: (context, doctorSnapshot) {
                          if (doctorSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return loadingIndicator(size,
                                circleHeight: size.height * .15,
                                circleWidth: size.width * .3);
                          } else if (doctorSnapshot.hasError) {
                            return Text('Error: ${doctorSnapshot.error}');
                          } else if (doctorSnapshot.hasData &&
                              doctorSnapshot.data != null) {
                            final doctor = doctorSnapshot.data!;
                            return homeUpcomingAppointment(
                                size,
                                context,
                                nextUpcomingAppointment,
                                doctor,
                                upcomingAvatarRadius);
                          } else {
                            return const Text('Doctor not found');
                          }
                        },
                      );
                    }
                  },
                ),
                SizedBox(height: size.height * .02),
                poppinsHeadText(text: 'Departments'),
                SizedBox(height: size.height * .01),
                homeCategory(context, size,
                    circleAvatarRadius: circleAvatarRadius),
                SizedBox(height: size.height * .01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    poppinsHeadText(text: 'Top Doctors'),
                    TextButton(
                      onPressed: () {
                        bottomProvider.userOnTap(2);
                      },
                      child: poppinsHeadText(
                        text: 'SEE ALL',
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * .01),
                Consumer<DoctorProvider>(
                  builder: (context, doctorValue, child) {
                    if (doctorValue.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (doctorValue.allDoctorList.isNotEmpty) {
                        final allDoctor = doctorValue.allDoctorList;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: allDoctor.length,
                          itemBuilder: (context, index) {
                            final doctors = allDoctor[index];
                            return Column(
                              children: [
                                AllDoctorsContainer(
                                  size: size,
                                  doctors: doctors,
                                  value: doctorValue,
                                  circleAvatarRadius: circleAvatarRadius,
                                ),
                                SizedBox(height: size.height * .02),
                              ],
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text('no doctors added')
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isUpcomingAppointment(AppointmentModel appointment) {
    final dateFormat = DateFormat('dd/MM/yyyy hh:mm a');
    try {
      String dateTimeStr = '${appointment.date!} ${appointment.time!}';
      dateTimeStr = dateTimeStr.replaceAll('\u202F', ' ');
      final appointmentDateTime = dateFormat.parse(dateTimeStr);
      return appointmentDateTime.isAfter(DateTime.now());
    } catch (e) {
      log('Error parsing date and time: $e');
      return false;
    }
  }

  DateTime parseDateTime(String date, String time) {
    final dateFormat = DateFormat('dd/MM/yyyy hh:mm a');
    String dateTimeStr = '$date $time';
    dateTimeStr = dateTimeStr.replaceAll('\u202F', ' ');
    return dateFormat.parse(dateTimeStr);
  }
}
