import 'package:flutter/material.dart';
import 'package:grocery_online_shop/controller/admin_provider.dart';
import 'package:grocery_online_shop/controller/appointment_provider.dart';
import 'package:grocery_online_shop/helper/loading_indicator.dart';
import 'package:grocery_online_shop/model/appointment_model.dart';
import 'package:grocery_online_shop/model/doctor_model.dart';
import 'package:grocery_online_shop/view/user/appointment/widgets_appointment.dart';
import 'package:grocery_online_shop/view/user/home/doctor_detail_screen.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';
import 'package:provider/provider.dart';


const double circleAvatarRadiusFraction = 0.1;

class CompletedAppointments extends StatelessWidget {
  const CompletedAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double circleAvatarRadius = size.shortestSide * circleAvatarRadiusFraction;
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 237, 237),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * .03, vertical: size.height * .02),
        child: Consumer<AppointmentProvider>(
          builder: (context, appointmentProvider, child) {
            if (appointmentProvider.isLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                color:  Colors.blue,
              ));
            }
            List<AppointmentModel> completedAppointments = appointmentProvider
                .allAppointmentList
                .where((appointment) => isAppointmentCompleted(
                    appointment.date!, appointment.time!))
                .toList();
            if (completedAppointments.isEmpty) {
              return Center(
                  child: poppinsHeadText(
                text: 'No completed appointments',
                color:  Colors.blue,
              ));
            }
            return ListView.builder(
              itemCount: completedAppointments.length,
              itemBuilder: (context, index) {
                final appointments = completedAppointments[index];
                return FutureBuilder<DoctorModel?>(
                  future: doctorProvider.getDoctorById(appointments.docId!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return loadingIndicator(size,
                          circleHeight: size.height * .15,
                          circleWidth: size.width * .3);
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final doctor = snapshot.data;
                      return Column(
                        children: [
                          appointmentScheduledContainer(size, context,
                              circleAvatarRadius: circleAvatarRadius,
                              appointment: appointments,
                              doctor: doctor!,
                              isUpcoming: false, onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DoctorDetailScreen(
                                          value: doctorProvider,
                                          userId: appointments.uId!,
                                          doctors: doctor,
                                        )));
                          }),
                          SizedBox(height: size.height * .02),
                        ],
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  bool isAppointmentCompleted(String appointmentDate, String appointmentTime) {
    List<String> timeParts = appointmentTime.split(RegExp(r'[:\s]'));
    int appointmentHour = int.parse(timeParts[0]);
    int appointmentMinute = int.parse(timeParts[1]);
    bool isPM = timeParts[2].toUpperCase() == 'PM';

    List<String> dateParts = appointmentDate.split('/');
    String formattedDate = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';

    if (isPM && appointmentHour != 12) {
      appointmentHour += 12;
    } else if (!isPM && appointmentHour == 12) {
      appointmentHour = 0;
    }

    DateTime now = DateTime.now();
    DateTime appointmentDateTime = DateTime.parse(formattedDate)
        .add(Duration(hours: appointmentHour, minutes: appointmentMinute));

    return appointmentDateTime.isBefore(now);
  }
}
