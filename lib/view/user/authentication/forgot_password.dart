import 'package:flutter/material.dart';
import 'package:grocery_online_shop/controller/authentication_provider.dart';
import 'package:grocery_online_shop/view/widgets/normal_widgets.dart';
import 'package:grocery_online_shop/view/widgets/snackbar_widget.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';
import 'package:grocery_online_shop/view/widgets/textformfield_widget.dart';
import 'package:provider/provider.dart';


class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: poppinsHeadText(
          text: 'Forgot Password',
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: size.height * .03, horizontal: size.width * .05),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Image(
              //   image: AssetImage(''),
              // ),
              SizedBox(
                height: size.height * .02,
              ),
              poppinsHeadText(
                  text:
                      'Enter Your Email and we will send you a password reset link to Email'),
              SizedBox(
                height: size.height * .02,
              ),
              Form(
                key: authProvider.forgotPasswordFormkey,
                child: CustomTextFormField(
                  controller: authProvider.signInEmailController,
                  validateMessage: 'Enter Email',
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(
                height: size.height * .02,
              ),
              elevatedButtonWidget(
                  shape: WidgetStateProperty.all(
                    BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  buttonText: 'Submit',
                  buttonWidth: size.width * .9,
                  buttonHeight: size.height * .065,
                  onPressed: () {
                    if (authProvider.forgotPasswordFormkey.currentState!
                        .validate()) {
                      authProvider.forgotPassword(
                        context,
                        email: authProvider.signInEmailController.text.trim(),
                        onError: (error) {
                          SnackBarWidget().showErrorSnackbar(context, error);
                        },
                        success: (success) {
                          SnackBarWidget()
                              .showSuccessSnackbar(context, success);
                        },
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
