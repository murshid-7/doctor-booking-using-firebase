import 'package:flutter/material.dart';
import 'package:grocery_online_shop/controller/appointment_provider.dart';
import 'package:grocery_online_shop/model/appointment_model.dart';
import 'package:grocery_online_shop/model/doctor_model.dart';
import 'package:grocery_online_shop/view/widgets/normal_widgets.dart';
import 'package:grocery_online_shop/view/widgets/snackbar_widget.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';
import 'package:provider/provider.dart';


Widget appointmentScheduledContainer(Size size, context,
    {circleAvatarRadius,
    bool? isUpcoming,
    onPressed,
    required AppointmentModel appointment,
    required DoctorModel doctor}) {
  final appointmentProvider =
      Provider.of<AppointmentProvider>(context, listen: false);
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFFFFFFFF),
      border: Border.all(color: const Color(0xFFFFFFFF)),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 10, vertical: size.height * .03),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: circleAvatarRadius,
                backgroundColor: const Color.fromARGB(255, 226, 84, 84),
                backgroundImage: doctor.image != null
                    ? NetworkImage(doctor.image!) as ImageProvider<Object>
                    : const AssetImage('assets/avatar-removebg-preview.png'),
              ),
              SizedBox(
                width: size.width * .035,
              ),
              SizedBox(
                height: size.height * .115,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    poppinsHeadText(
                      text: 'Dr. ${doctor.fullName}',
                      color: const Color(0xFF1D1617),
                    ),
                    poppinsText(
                      text: 'Specialty: ${doctor.category}',
                      fontSize: 14,
                    ),
                    poppinsText(
                      text:
                          'Date: ${appointment.date}  Time: ${appointment.time}',
                      fontSize: 14,
                    ),
                    SizedBox(height: size.height * .01),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            color: Color.fromARGB(255, 240, 236, 236),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (isUpcoming!)
                OutlinedButton(
                  style: ButtonStyle(
                    side: WidgetStateProperty.all(
                      const BorderSide(color: Color(0xFFED3443), width: 1.2),
                    ),
                  ),
                  onPressed: () {
                    confirmationDialog(context, size,
                        dialogWidth: size.width * .6,
                        dialogheight: size.height * .16,
                        height: size.height * .02,
                        alertMessage: 'Proceed to cancel Your Appointment ?',
                        confirmText: 'Confirm', onPressedConfirm: () async {
                      await appointmentProvider.cancelAppointment(
                        appointment.id!,
                        (error) {
                          SnackBarWidget().showErrorSnackbar(context, error);
                        },
                      );
                      Navigator.pop(context);
                    });
                  },
                  child: poppinsHeadText(
                    text: 'Cancel Booking',
                    color: const Color(0xFFED3443),
                    fontSize: 13,
                  ),
                ),
              elevatedButtonWidget(
                  buttonWidth: size.width * (isUpcoming ? .4 : .8),
                  buttonText: isUpcoming ? 'Reschedule' : 'Book Again',
                  onPressed: onPressed)
            ],
          ),
        ],
      ),
    ),
  );
}
