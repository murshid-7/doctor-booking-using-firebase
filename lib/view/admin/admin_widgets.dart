import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_online_shop/controller/admin_provider.dart';
import 'package:grocery_online_shop/view/widgets/snackbar_widget.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';
import 'package:grocery_online_shop/view/widgets/textformfield_widget.dart';


Widget adminDoctorAddFields(
  Size size,
  context,
  DoctorProvider adminProvider,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              controller: adminProvider.doctorNameController,
              hintText: 'Full Name',
              validateMessage: 'Enter Name',
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              controller: adminProvider.doctorAgeController,
              hintText: 'Age',
              width: size.width * .2,
              validateMessage: 'Enter Age',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: dropDownTextFormField(
                hintText: 'Gender',
                value: adminProvider.selectedGender,
                items: adminProvider.genders.map((gender) {
                  return DropdownMenuItem(
                      value: gender,
                      child: interSubText(
                        text: gender,
                      ));
                }).toList(),
                onChanged: (value) {
                  adminProvider.selectedGender = value.toString();
                },
                validateMessage: 'select your gender'),
          )
        ],
      ),
      dropDownTextFormField(
          hintText: 'Category',
          value: adminProvider.selectedCategory,
          items: adminProvider.category.map((category) {
            return DropdownMenuItem(
                value: category,
                child: interSubText(
                  text: category,
                ));
          }).toList(),
          onChanged: (value) {
            adminProvider.selectedCategory = value.toString();
          },
          validateMessage: 'select category'),
      dropDownTextFormField(
          hintText: 'Position',
          value: adminProvider.selectedPosition,
          items: adminProvider.position.map((position) {
            return DropdownMenuItem(
                value: position,
                child: interSubText(
                  text: position,
                ));
          }).toList(),
          onChanged: (value) {
            adminProvider.selectedPosition = value.toString();
          },
          validateMessage: 'select position'),
      Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              controller: adminProvider.doctorAboutController,
              maxLines: 4,
              labelText: 'About Doctor',
              validateMessage: 'tPlease fill out this field',
            ),
          ),
        ],
      ),
      poppinsHeadText(text: 'Working information'),
      Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              controller: adminProvider.doctorAppointmentTimeController,
              labelText: "inspection start time",
              validateMessage: 'pick inspection time',
              keyboardType: TextInputType.datetime,
              initialTime: TimeOfDay.now(),
              onTimePicked: (pickedTime) {
                if (pickedTime != null) {
                  if (pickedTime.hour >= 9 && pickedTime.hour <= 17) {
                    adminProvider.doctorAppointmentTimeController.text =
                        pickedTime.format(context);
                  } else {
                    SnackBarWidget().showErrorSnackbar(context,
                        'start time must be between 9:00 AM and 5:00 PM');
                  }
                }
              },
            ),
          ),
          SizedBox(width: size.width * .08),
          Expanded(
            child: CustomTextFormField(
              controller: adminProvider.doctorAppointmentEndTimeController,
              labelText: 'inspection end time',
              validateMessage: 'pick inspection end time',
              keyboardType: TextInputType.datetime,
              initialTime: TimeOfDay.now(),
              onTimePicked: (pickedTime) {
                if (pickedTime != null) {
                  if (pickedTime.hour <= 18) {
                    adminProvider.doctorAppointmentEndTimeController.text =
                        pickedTime.format(context);
                  } else {
                    SnackBarWidget().showErrorSnackbar(
                        context, 'End time must be 6:00 PM or earlier');
                  }
                }
              },
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              controller: adminProvider.doctorPatientsController,
              labelText: 'Patients',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(width: size.width * .08),
          Expanded(
            child: CustomTextFormField(
              controller: adminProvider.doctorExperienceController,
              labelText: 'Experience',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(width: size.width * .08),
          Expanded(
            child: CustomTextFormField(
              controller: adminProvider.doctorRatingController,
              labelText: 'Rating',
              validateMessage: 'Enter Rating',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    ],
  );
}
