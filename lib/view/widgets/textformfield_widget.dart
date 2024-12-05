import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_online_shop/controller/appointment_provider.dart';

class CustomTextFormField extends StatelessWidget {
  final double? width;
  final int? maxLines;
  final String? hintText;
  final String? labelText;
  final bool? obscureText;
  final String? suffixText;
  final String? prefixText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  final TimeOfDay? initialTime;
  final String? validateMessage;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? enabledBorder;
  final Function(TimeOfDay?)? onTimePicked;
  final OutlineInputBorder? focusErrorBorder;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField({
    super.key,
    this.width,
    this.maxLines,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.suffixText,
    this.prefixIcon,
    this.prefixText,
    this.suffixIcon,
    this.obscureText,
    this.initialTime,
    this.onTimePicked,
    this.keyboardType,
    this.enabledBorder,
    this.focusedBorder,
    this.inputFormatters,
    this.validateMessage,
    this.focusErrorBorder,
    required this.controller,
  });

  static final RegExp emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  static final RegExp timeRegex = RegExp(
    r'^(0?[1-9]|1[0-2]):[0-5][0-9] [APMapm]{2}$',
  );

  Future<void> _selectTime(context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
    if (picked != null && onTimePicked != null) {
      onTimePicked!(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (keyboardType == TextInputType.datetime) {
          _selectTime(context);
        }
      },
      child: AbsorbPointer(
        absorbing: keyboardType == TextInputType.datetime,
        child: TextFormField(
          onChanged: onChanged,
          obscureText: obscureText ?? false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validateMessage ?? 'Enter value';
            } else if (keyboardType == TextInputType.emailAddress &&
                !emailRegex.hasMatch(value)) {
              return 'Enter a valid email address';
            } else if (keyboardType == TextInputType.datetime &&
                !timeRegex.hasMatch(value)) {
              return 'Enter a valid time';
            } else if (keyboardType == TextInputType.phone &&
                value.length != 10) {
              return 'Enter 10 digits';
            } else {
              return null;
            }
          },
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          controller: controller,
          maxLines: maxLines ?? 1,
          decoration: InputDecoration(
            suffixText: suffixText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            prefixText: prefixText,
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              color: const Color(0xFF98A3B3),
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            labelText: labelText,
            labelStyle: GoogleFonts.inter(
              color: const Color(0xFF98A3B3),
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            fillColor: const Color.fromARGB(255, 225, 227, 234),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            focusedErrorBorder: focusErrorBorder,
          ),
        ),
      ),
    );
  }
}

Widget dropDownTextFormField(
    {validateMessage, value, items, onChanged, hintText}) {
  return DropdownButtonFormField<String>(
    icon: const SizedBox.shrink(),
    validator: (value) {
      if (value == null) {
        return validateMessage;
      } else {
        return null;
      }
    },
    value: value,
    items: items,
    onChanged: onChanged,
    decoration: InputDecoration(
      suffixIcon: const Icon(EneftyIcons.arrow_down_outline),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: const Color.fromARGB(255, 225, 227, 234),
      hintText: hintText,
      hintStyle: GoogleFonts.inter(
        color: const Color(0xFF98A3B3),
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
    ),
  );
}

Widget bookingDateTextFormField(
    BuildContext context, AppointmentProvider userProvider,
    {TextInputType? keyboardType}) {
  final RegExp dateRegex = RegExp(
    r'^\d{2}/\d{2}/\d{4}$',
  );

  final DateTime now = DateTime.now();
  final DateTime tomorrow = now.add(const Duration(days: 1));

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tomorrow,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      userProvider.userBookingDateController.text = formattedDate;
      userProvider.setSelectedDate(formattedDate);
    }
  }

  return GestureDetector(
    onTap: () {
      if (keyboardType == TextInputType.datetime) {
        selectDate(context);
      }
    },
    child: AbsorbPointer(
      absorbing: keyboardType == TextInputType.datetime,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Pick a date';
          } else if (keyboardType == TextInputType.datetime &&
              !dateRegex.hasMatch(value)) {
            return 'Pick a valid date';
          } else {
            return null;
          }
        },
        keyboardType: keyboardType,
        controller: userProvider.userBookingDateController,
        decoration: InputDecoration(
          suffixIcon: const Icon(EneftyIcons.calendar_2_outline),
          hintText: 'Appointment Date',
          hintStyle: GoogleFonts.inter(
            color: const Color(0xFF98A3B3),
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          fillColor: const Color.fromARGB(255, 225, 227, 234),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ),
  );
}
