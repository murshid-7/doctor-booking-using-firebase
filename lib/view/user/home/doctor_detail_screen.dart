import 'package:grocery_online_shop/controller/admin_provider.dart';
import 'package:grocery_online_shop/controller/appointment_provider.dart';
import 'package:grocery_online_shop/model/appointment_model.dart';
import 'package:grocery_online_shop/model/doctor_model.dart';
import 'package:grocery_online_shop/view/user/home/home_widgets.dart';
import 'package:grocery_online_shop/view/user/user_widgets.dart';
import 'package:grocery_online_shop/view/widgets/normal_widgets.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';
import 'package:grocery_online_shop/view/widgets/textformfield_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enefty_icons/enefty_icons.dart';

class DoctorDetailScreen extends StatelessWidget {
  final DoctorModel? doctors;
  final DoctorProvider value;
  final String userId;
  

  const DoctorDetailScreen(
      {super.key, this.doctors, required this.value, required this.userId});

  @override
  Widget build(BuildContext context) {
     
    Size size = MediaQuery.of(context).size;
    final appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);
    List<String> times = _generateTimeSlots(
        doctors?.startTime?.trim() ?? '09:00 AM',
        doctors?.endTime?.trim() ?? '05:00 PM');

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            appointmentProvider.clearAppointmentControllers();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFFFFFFFF),
        title: poppinsText(
            text: 'Dr. ${doctors!.fullName}',
            color: const Color(0xFF1A1A1A),
            fontSize: 18,
            fontWeight: FontWeight.bold),
        centerTitle: true,
        actions: [
          Consumer<DoctorProvider>(
            builder: (context, value, child) => IconButton(
              onPressed: () {
                final wish = value.wishListCheck(doctors!);
                value.wishlistClicked(doctors!.id!, wish);
              },
              icon: value.wishListCheck(doctors!)
                  ? const Icon(
                      Icons.favorite_border_rounded,
                      size: 30,
                      color: Colors.blue,
                    )
                  : const Icon(
                      Icons.favorite_rounded,
                      size: 30,
                      color: Colors.blue,
                    ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.035, vertical: size.height * 0.02),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              doctorDetailsScreenContainer(size,
                  width: size.width * .9,
                  fullName: 'Dr. ${doctors!.fullName}',
                  age: doctors!.age,
                  gender: doctors!.gender,
                  category: doctors!.category,
                  position: doctors!.position,
                  image: doctors!.image),
              SizedBox(height: size.height * .03),
              doctorDetailsExperienceRow(size,
                  patient: doctors!.patients,
                  experience: doctors!.experience,
                  rating: doctors!.rating),
              SizedBox(height: size.height * .03),
              poppinsHeadText(text: 'About me'),
              SizedBox(height: size.height * .02),
              SizedBox(
                child: poppinsSmallText(
                    text: doctors!.aboutDoctor, color: const Color(0xFF344154)),
              ),
              SizedBox(height: size.height * .03),
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
                    text: '${doctors!.startTime}  -  ${doctors!.endTime}',
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
                        bool isBooked = _isTimeSlotBooked(
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
              elevatedButtonWidget(
                  buttonHeight: size.height * .06,
                  buttonWidth: size.width * .9,
                  buttonText: 'BOOK APPOINTMENT',
                  onPressed: () {
                    final selectedDate = appointmentProvider.selectedDate;
                    final selectedTime = appointmentProvider.selectedTime;
                    if (selectedDate != null && selectedTime != null) {
                      final appointment = AppointmentModel(
                          uId: userId,
                          docId: doctors!.id,
                          date: selectedDate,
                          time: selectedTime);
                      successDialogBox(context, size,
                          userProvider: appointmentProvider,
                          appointment: appointment,
                          isAppointment: true,
                          headMessage: 'Choose Your Payment',
                          fees: doctors!.patients,
                          subText:
                              'Please select a payment method to proceed appointment with Dr.${doctors!.fullName}.',
                          elevatedButtonHeight: size.height * .05,
                          elevatedButtonWidth: size.width * .7,
                          height: size.height * .02,
                          width: size.width * .8,
                          dialogheight: size.height * .48,
                          dialogWidth: size.width * .2,
                          bookingTime: selectedTime,
                          bookingDate: selectedDate,
                          doctorName: doctors!.fullName,
                          image: doctors!.image);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Please select a date and time'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
              SizedBox(height: size.height * .02),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _generateTimeSlots(String startTime, String endTime) {
    List<String> timeSlots = [];

    try {
      DateTime start = _parseTime(startTime);
      DateTime end = _parseTime(endTime);

      while (start.isBefore(end)) {
        timeSlots.add(_formatTime(start));
        start = start.add(const Duration(minutes: 30));
      }
    } catch (e) {
      debugPrint('Error generating time slots: $e');
    }

    return timeSlots;
  }

  bool _isTimeSlotBooked(
      String time, List<AppointmentModel> appointments, String? selectedDate) {
    return appointments.any((appointment) =>
        appointment.time == time &&
        appointment.date == selectedDate &&
        appointment.status == null &&
        appointment.status != 'canceled');
  }

  DateTime _parseTime(String time) {
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

  String _formatTime(DateTime time) {
    final format = DateFormat.jm();
    return format.format(time);
  }
}
