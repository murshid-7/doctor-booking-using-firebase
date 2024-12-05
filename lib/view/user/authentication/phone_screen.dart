import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_online_shop/controller/authentication_provider.dart';
import 'package:grocery_online_shop/view/widgets/normal_widgets.dart';
import 'package:grocery_online_shop/view/widgets/snackbar_widget.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';
import 'package:grocery_online_shop/view/widgets/textformfield_widget.dart';
import 'package:provider/provider.dart';
import 'package:enefty_icons/enefty_icons.dart';

class PhoneScreen extends StatelessWidget {
  const PhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          title: poppinsHeadText(
        text: 'OTP Verification',
        fontSize: 20,
      )),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(height: size.height * .07),
          Container(
            height: size.height * .4,
            padding: EdgeInsets.symmetric(horizontal: size.width * .08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Form(
                  key: authProvider.phoneFormkey,
                  child: Consumer<AuthenticationProvider>(
                    builder: (context, authValue, child) => CustomTextFormField(
                      controller: authProvider.phoneController,
                      hintText: 'Enter mobile Number',
                      validateMessage: 'Enter mobile number',
                      prefixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                countryListTheme: const CountryListThemeData(
                                    bottomSheetHeight: 500),
                                onSelect: (value) {
                                  authValue.selectCountry = value;
                                  authValue.notifyCountryChanged();
                                },
                              );
                            },
                            child: poppinsHeadText(
                              text:
                                  "${authValue.selectCountry.flagEmoji}+${authValue.selectCountry.phoneCode}",
                            ),
                          ),
                        ],
                      ),
                      suffixIcon: const Icon(
                        EneftyIcons.call_outline,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ),
                elevatedButtonWidget(
                  shape: WidgetStateProperty.all(
                    BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  buttonHeight: size.height * .06,
                  bgColor: '',
                  buttonText: 'Generate otp',
                  buttonWidth: size.width * .8,
                  onPressed: () {
                    if (authProvider.phoneFormkey.currentState!.validate()) {
                      try {
                        if (authProvider.phoneController.text.length == 10) {
                          authProvider.getOtp(
                            "+${authProvider.selectCountry.phoneCode}${authProvider.phoneController.text}",
                          );
                          authProvider.showOtpFieldTrue();
                          SnackBarWidget()
                              .showSuccessSnackbar(context, 'otp sended');
                        } else {
                          SnackBarWidget().showErrorSnackbar(
                              context, 'please check your phone number');
                        }
                      } catch (e) {
                        SnackBarWidget().showErrorSnackbar(
                            context, 'please check your phone number');
                      }
                    }
                  },
                ),
                Consumer<AuthenticationProvider>(
                  builder: (context, value, child) {
                    if (authProvider.showOtpField) {
                      return Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: authProvider.otpFormkey,
                              child: CustomTextFormField(
                                controller: authProvider.otpController,
                                keyboardType: TextInputType.number,
                                hintText: 'Enter otp',
                                validateMessage: 'Enter otp Here',
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: size.width * .04),
                          Expanded(
                            child: elevatedButtonWidget(
                              buttonHeight: size.height * .065,
                              shape: WidgetStateProperty.all(
                                BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              buttonText: 'verify otp',
                              onPressed: () {
                                if (authProvider.otpFormkey.currentState!
                                    .validate()) {
                                  try {
                                    authProvider.verifyOtp(
                                        authProvider.otpController.text,
                                        context, error: () {
                                      SnackBarWidget().showErrorSnackbar(
                                          context, 'Try again later');
                                    });
                                  } catch (e) {
                                    SnackBarWidget().showErrorSnackbar(
                                        context, "Invalid OTP $e");
                                  }
                                }
                              },
                              bgColor: const Color(0xFF1995AD),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
