import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_online_shop/controller/authentication_provider.dart';
import 'package:grocery_online_shop/view/user/authentication/forgot_password.dart';
import 'package:grocery_online_shop/view/user/authentication/phone_screen.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';
import 'package:grocery_online_shop/view/widgets/textformfield_widget.dart';
import 'package:provider/provider.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:google_fonts/google_fonts.dart';


Widget loginTypeTexts({text}) {
  return Text(text,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 15));
}

Widget loginTypeOutlinedButton(Size size, {text, onPressed}) {
  return SizedBox(
    width: size.width * 0.75,
    height: size.height * .063,
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white, width: 1.8),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: poppinsText(
          textAlign: TextAlign.center,
          text: text,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    ),
  );
}

Widget editProfileFields(size, AuthenticationProvider authProvider,
    {userNameController, ageController, phoneController}) {
  return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
    CustomTextFormField(
      controller: userNameController,
      hintText: 'Full Name',
    ),
    CustomTextFormField(
      controller: ageController,
      hintText: 'Age',
    ),
    CustomTextFormField(
      controller: phoneController,
      hintText: ' Phone Number',
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.phone,
    ),
    dropDownTextFormField(
        hintText: 'Gender',
        value: authProvider.selectedGender,
        items: authProvider.genders.map((gender) {
          return DropdownMenuItem(
              value: gender,
              child: interSubText(
                text: gender,
              ));
        }).toList(),
        onChanged: (value) {
          authProvider.selectedGender = value.toString();
        },
        validateMessage: 'select your gender'),
  ]);
}

authenticationBoxRow(Size size, context,
    {AuthenticationProvider? authenticationProvider}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InkWell(
        onTap: () async {
          authenticationProvider!.googleSignIn(context);
        },
        child: Container(
          height: size.height * .065,
          width: size.width * .2,
          decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(255, 199, 212, 226)),
              borderRadius: BorderRadius.circular(18)),
          child: Transform.scale(
            scale: 0.5,
            child: Image.network(
              'https://cdn.iconscout.com/icon/free/png-256/free-google-1772223-1507807.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      SizedBox(width: size.width * .1),
      InkWell(
        onTap: () {
          authenticationProvider!.clearSignInControllers();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PhoneScreen()));
        },
        child: Container(
          height: size.height * .065,
          width: size.width * .2,
          decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(255, 199, 212, 226)),
              borderRadius: BorderRadius.circular(18)),
          child: Transform.scale(
            scale: 0.55,
            child: Image.network(
              'https://cdn-icons-png.freepik.com/256/100/100313.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget createAccountTextFormFields(
  AuthenticationProvider authProvider,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      CustomTextFormField(
        controller: authProvider.createAccountUserNameController,
        hintText: 'User Name',
        validateMessage: 'Enter User Name',
      ),
      CustomTextFormField(
        controller: authProvider.createAccountEmailController,
        hintText: 'Email',
        validateMessage: 'Enter Email',
        keyboardType: TextInputType.emailAddress,
      ),
      CustomTextFormField(
        controller: authProvider.passwordController,
        hintText: 'Password',
        obscureText: authProvider.createAccountObscureText,
        suffixIcon: IconButton(
          onPressed: () {
            authProvider.createAccountObscureChange();
          },
          icon: Icon(authProvider.createAccountObscureText
              ? EneftyIcons.eye_slash_outline
              : EneftyIcons.eye_outline),
        ),
        validateMessage: 'Enter password',
      ),
      CustomTextFormField(
        controller: authProvider.confirmPasswordController,
        hintText: 'Confirm Password',
        obscureText: authProvider.createAccountConfirmObscureText,
        suffixIcon: IconButton(
          onPressed: () {
            authProvider.createAccountConfirmObscureChange();
          },
          icon: Icon(authProvider.createAccountConfirmObscureText
              ? EneftyIcons.eye_slash_outline
              : EneftyIcons.eye_outline),
        ),
        validateMessage: 'Renter Your Password',
      ),
    ],
  );
}

Widget signInTextFormField(
    Size size, context, AuthenticationProvider authProvider) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      CustomTextFormField(
        controller: authProvider.signInEmailController,
        hintText: 'Email',
        validateMessage: 'Enter Your Email',
        keyboardType: TextInputType.emailAddress,
      ),
      SizedBox(height: size.height * .02),
      Consumer<AuthenticationProvider>(
        builder: (context, value, child) => CustomTextFormField(
          controller: value.signInPasswordController,
          hintText: 'Password',
          validateMessage: 'Enter Your Password',
          obscureText: value.signInObscureText,
          suffixIcon: IconButton(
            onPressed: () {
              value.signInObscureChange();
            },
            icon: Icon(value.signInObscureText
                ? EneftyIcons.eye_slash_outline
                : EneftyIcons.eye_outline),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen()));
              },
              child: poppinsText(
                  text: 'Forgot the password?',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue)),
        ],
      ),
    ],
  );
}
