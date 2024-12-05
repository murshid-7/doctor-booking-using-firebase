// ignore_for_file: use_build_context_synchronously

import 'package:grocery_online_shop/controller/appointment_provider.dart';
import 'package:grocery_online_shop/model/appointment_model.dart';
import 'package:grocery_online_shop/model/doctor_model.dart';
import 'package:grocery_online_shop/view/user/home/home_widgets.dart';
import 'package:grocery_online_shop/view/widgets/normal_widgets.dart';
import 'package:grocery_online_shop/view/widgets/snackbar_widget.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';
import 'package:grocery_online_shop/view/widgets/textformfield_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enefty_icons/enefty_icons.dart';

successDialogBox(localContext, Size size,
    {elevatedButtonHeight,
    elevatedButtonWidth,
    height,
    width,
    image,
    fees,
    doctorName,
    bookingTime,
    bookingDate,
    dialogheight,
    dialogWidth,
    headMessage,
    subText,
    AppointmentModel? appointment,
    AppointmentProvider? userProvider,
    required bool? isAppointment}) {
  return showDialog(
    context: localContext,
    builder: (context) {
      return AlertDialog(
        title: SizedBox(
          height: dialogheight,
          width: dialogWidth,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(height: height),
                CircleAvatar(
                    radius: size.width * .15,
                    backgroundColor: Colors.blue,
                    backgroundImage: image != null
                        ? NetworkImage(image)
                        : const AssetImage('assets/avatar-removebg-preview.png')
                            as ImageProvider),
                SizedBox(height: height),
                poppinsHeadText(
                  textAlign: TextAlign.center,
                  text: headMessage,
                  fontSize: 20,
                  color: Colors.blue,
                ),
                SizedBox(height: height),
                SizedBox(
                  width: width,
                  child: poppinsText(
                    textAlign: TextAlign.center,
                    text: subText,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF101828),
                  ),
                ),
                SizedBox(height: height),
                isAppointment!
                    ? Column(
                        children: [
                          elevatedButtonWidget(
                              buttonHeight: elevatedButtonHeight,
                              buttonWidth: elevatedButtonWidth,
                              onPressed: () async {
                                bool success =
                                    await userProvider!.addAppointment(
                                  appointment!,
                                  (error) {
                                    SnackBarWidget()
                                        .showErrorSnackbar(localContext, error);
                                  },
                                );
                                Navigator.pop(localContext);
                                if (success) {
                                  appointmentDialogBox(localContext, size,
                                      doctorName: doctorName,
                                      bookingTime: bookingTime,
                                      bookingDate: bookingDate,
                                      doctorImage: image);
                                } else {
                                  Navigator.pop(localContext);
                                  userProvider.selectedTime = null;
                                }
                              },
                              buttonText: 'Pay at Clinic'),

                          // elevatedButtonWidget(
                          //     buttonHeight: elevatedButtonHeight,
                          //     buttonWidth: elevatedButtonWidth,
                          //     onPressed: () async {
                          //       int amount = 20000;

                          //       bool success =
                          //           await userProvider!.addAppointment(
                          //         appointment!,
                          //         (error) {
                          //           SnackBarWidget()
                          //               .showErrorSnackbar(localContext, error);
                          //         },
                          //       );
                          //       Navigator.pop(localContext);
                          //       if (success) {
                          //         appointmentDialogBox(localContext, size,
                          //             doctorName: doctorName,
                          //             bookingTime: bookingTime,
                          //             bookingDate: bookingDate,
                          //             doctorImage: image);
                          //       } else {
                          //         Navigator.pop(localContext);
                          //         userProvider.selectedTime = null;
                          //       }
                          //     },
                          //     buttonText: 'Pay Online'),
                        ],
                      )
                    : elevatedButtonWidget(
                        buttonHeight: size.height * .06,
                        buttonText: 'OK',
                        buttonWidth: size.width * .5,
                        onPressed: () {
                          Navigator.pop(localContext);
                        },
                      )
              ],
            ),
          ),
        ),
      );
    },
  );
}

appointmentDialogBox(routeContext, Size size,
    {doctorName, bookingTime, bookingDate, doctorImage}) {
  return showDialog(
    context: routeContext,
    builder: (context) {
      return AlertDialog(
        title: SizedBox(
          height: size.height * .43,
          width: size.width * .2,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(height: size.height * .02),
                CircleAvatar(
                  radius: size.width * .15,
                  backgroundColor: const Color(0xFF1995AD),
                  backgroundImage: doctorImage != null
                      ? NetworkImage(doctorImage)
                      : const AssetImage('assets/avatar-removebg-preview.png')
                          as ImageProvider,
                ),
                SizedBox(height: size.height * .02),
                poppinsHeadText(
                  textAlign: TextAlign.center,
                  text: 'Appointment Success',
                  fontSize: 20,
                  color: const Color(0xFF1995AD),
                ),
                SizedBox(height: size.height * .02),
                SizedBox(
                  width: size.width * .8,
                  child: poppinsText(
                    textAlign: TextAlign.center,
                    text:
                        'Your appointment with Dr. $doctorName on $bookingDate at $bookingTime has been confirmed  ',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF101828),
                  ),
                ),
                SizedBox(height: size.height * .02),
                elevatedButtonWidget(
                    buttonHeight: size.height * .05,
                    buttonWidth: size.width * .7,
                    onPressed: () {
                      Navigator.pop(routeContext);
                      Navigator.pop(routeContext);
                    },
                    buttonText: 'OK')
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget showBottom(Size size, context,
    {required DoctorModel? doctor,
    required AppointmentModel? appointment,
    bool? home}) {
  final appointmentProvider =
      Provider.of<AppointmentProvider>(context, listen: false);

  void refreshAppointments() {
    Provider.of<AppointmentProvider>(context, listen: false)
        .getUserAppointments();
  }

  DateTime parseTime(String time) {
    final trimmedTime = time.trim();
    final components = trimmedTime.split(' ');
    final hourMinute = components[0].split(':');
    final hour = int.tryParse(hourMinute[0]);
    final minute = int.tryParse(hourMinute[1]);
    final isPM = components[1].toUpperCase() == 'PM';
    if (hour != null && minute != null) {
      final dateTime = DateTime(1, 1, 1, isPM ? hour + 12 : hour, minute);
      return dateTime;
    }
    throw const FormatException('Invalid time format');
  }

  bool isTimeSlotBooked(
      String time, List<AppointmentModel> appointments, String? selectedDate) {
    return appointments.any((appointment) =>
        appointment.time == time &&
        appointment.date == selectedDate &&
        appointment.status == null &&
        appointment.status != 'canceled');
  }

  String formatTime(DateTime time) {
    final format = DateFormat.jm();
    return format.format(time);
  }

  List<String> generateTimeSlots(String startTime, String endTime) {
    List<String> timeSlots = [];

    try {
      DateTime start = parseTime(startTime);
      DateTime end = parseTime(endTime);

      while (start.isBefore(end)) {
        timeSlots.add(formatTime(start));
        start = start.add(const Duration(minutes: 30));
      }
    } catch (e) {
      debugPrint('Error generating time slots: $e');
    }

    return timeSlots;
  }

  List<String> times = generateTimeSlots(
      doctor?.startTime?.trim() ?? '09:00 AM',
      doctor?.endTime?.trim() ?? '05:00 PM');

  appointmentProvider.userBookingDateController.text = appointment!.date!;

  return Stack(children: [
    Container(
      height: size.height * .6,
      width: size.width * 1,
      decoration: const BoxDecoration(
        color: Color(0xFFA1D6E2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * .05, vertical: size.height * .05),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Center(
              //   child: poppinsHeadText(
              //     text: 'Reshedule',
              //     fontSize: 23,
              //     color: const Color(0xFF1995AD),
              //   ),
              // ),
              SizedBox(height: size.height * .02),
              poppinsHeadText(text: 'Working information'),
              SizedBox(height: size.height * .02),
              Row(
                children: [
                  const Icon(
                    EneftyIcons.calendar_2_outline,
                    color: Color(0xFF778293),
                  ),
                  SizedBox(width: size.width * .02),
                  poppinsSmallText(
                    text: 'Monday-Friday, ',
                    color: const Color(0xFF344154),
                  ),
                  poppinsSmallText(
                    text: '${doctor!.startTime}  -  ${doctor.endTime}',
                    color: const Color(0xFF344154),
                  ),
                ],
              ),
              SizedBox(height: size.height * .02),
              poppinsHeadText(text: 'Select Date'),
              SizedBox(height: size.height * .02),
              bookingDateTextFormField(context, appointmentProvider,
                  keyboardType: TextInputType.datetime),
              SizedBox(height: size.height * .02),
              poppinsHeadText(
                text: 'Select Hour',
              ),
              SizedBox(height: size.height * .02),
              SizedBox(
                child: Consumer<AppointmentProvider>(
                  builder: (context, value, child) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1 / .4,
                        crossAxisCount: 3,
                        crossAxisSpacing: size.width * 0.02,
                        mainAxisSpacing: size.height * .01,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: times.length,
                      itemBuilder: (BuildContext context, int index) {
                        String time = times[index];
                        bool isSelected = value.selectedTime == time;
                        bool isBooked = isTimeSlotBooked(
                            time, value.allAppointmentList, value.selectedDate);
                        return SizedBox(
                          height: size.height * .0007,
                          width: size.width * .5,
                          child: doctorDetailsTimeButton(
                            onPressed: () {
                              if (!isBooked) {
                                value.setSelectedTime(time);
                              }
                            },
                            isSelected: isSelected,
                            isBooked: isBooked,
                            time: time,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: size.height * .02),
            ],
          ),
        ),
      ),
    ),
    SizedBox(height: size.height * .02),
    Positioned(
      bottom: size.height * .01,
      left: size.width * .08,
      child: Row(
        children: [
          elevatedButtonWidget(
              buttonHeight: size.height * .06,
              buttonWidth: size.width * .22,
              bgColor: Colors.blue,
              buttonText: 'Back',
              onPressed: () {
                Navigator.pop(context);
                appointmentProvider.clearAppointmentControllers();
              }),
          SizedBox(
            width: size.width * .02,
          ),
          elevatedButtonWidget(
            buttonHeight: size.height * .06,
            buttonWidth: size.width * .65,
            bgColor: Colors.blue,
            buttonText: 'Reshedule Appointment',
            onPressed: () async {
              final selectedDate = appointmentProvider.selectedDate;
              final selectedTime = appointmentProvider.selectedTime;
              final resheduledAppointment = AppointmentModel(
                  id: appointment.id,
                  docId: appointment.docId,
                  uId: appointment.uId,
                  date: selectedDate ?? appointment.date,
                  time: selectedTime ?? appointment.time);

              await appointmentProvider.updateAppointment(
                  appointment.id!, resheduledAppointment);

              Navigator.pop(context);
              refreshAppointments();
              appointmentProvider.clearAppointmentControllers();
              if (home == false) {
                successDialogBox(context, size,
                    userProvider: appointmentProvider,
                    isAppointment: false,
                    headMessage: 'Your Appointment Has Been Resheduled',
                    elevatedButtonHeight: size.height * .05,
                    elevatedButtonWidth: size.width * .7,
                    height: size.height * .02,
                    width: size.width * .8,
                    dialogheight: size.height * .45,
                    dialogWidth: size.width * .2,
                    image: doctor.image,
                    subText:
                        'Your appointment with Dr.${doctor.fullName} was Resheduled to ${selectedDate ?? appointment.date} at ${selectedTime ?? appointment.time}');
                appointmentProvider.clearAppointmentControllers();
              } else {
                SnackBarWidget().showSuccessSnackbar(context,
                    'Appointmet with Dr.${doctor.fullName} Resheduled');
              }
            },
          ),
        ],
      ),
    )
  ]);
}
