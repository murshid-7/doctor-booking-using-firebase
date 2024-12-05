import 'package:flutter/material.dart';
import 'package:grocery_online_shop/controller/authentication_provider.dart';
import 'package:grocery_online_shop/view/user/authentication/auth_widgets.dart';
import 'package:grocery_online_shop/view/user/authentication/sign_in.dart';
import 'package:grocery_online_shop/view/widgets/snackbar_widget.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';
import 'package:grocery_online_shop/view/widgets/user_bottom_bar.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white, 
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      authProvider.clearCreateAccountControllers();
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 25,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      authProvider.clearCreateAccountControllers();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      );
                    },
                    child: poppinsText(
                      text: 'Sign In',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * .04),
              Text(
                'Create Your Account',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: size.height * .02),
              SizedBox(
                height: size.height * .42,
                width: size.width * .9,
                child: Form(
                  key: authProvider.createAccountFormkey,
                  child: Consumer<AuthenticationProvider>(
                    builder: (context, value, child) {
                      return createAccountTextFormFields(value);
                    },
                  ),
                ),
              ),
              SizedBox(height: size.height * .02),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.black,
                  minimumSize: Size(size.width * 0.9, size.height * 0.058),
                ),
                onPressed: () async {
                  if (authProvider.createAccountFormkey.currentState!
                      .validate()) {
                    if (authProvider.passwordController.text.length < 6) {
                      SnackBarWidget().showErrorSnackbar(
                        context,
                        'Password must contain 6 characters',
                      );
                      return;
                    }
                    try {
                      if (authProvider.createAccountEmailController.text ==
                          'admin@gmail.com') {
                        SnackBarWidget().showErrorSnackbar(context,
                            'Email address already exists or is invalid');
                      } else if (authProvider.passwordController.text ==
                          authProvider.confirmPasswordController.text) {
                        await authProvider.accountCreate(
                            authProvider.createAccountEmailController.text,
                            authProvider.passwordController.text);
                        authProvider.addUser();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserBottomBar(),
                            ),
                            (route) => false);
                        authProvider.clearCreateAccountControllers();
                      } else {
                        SnackBarWidget().showErrorSnackbar(
                            context, 'Passwords do not match');
                      }
                    } catch (error) {
                      SnackBarWidget().showErrorSnackbar(context,
                          'Email address already exists or is invalid');
                    }
                  }
                },
                child: const Text(
                  'CREATE ACCOUNT',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: size.height * .02),
              Row(children: [
                const Flexible(
                  child: Divider(thickness: 1),
                ),
                poppinsText(
                  text: '  or create with  ',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                const Flexible(
                  child: Divider(thickness: 1),
                )
              ]),
              SizedBox(height: size.height * .02),
              authenticationBoxRow(size, context,
                  authenticationProvider: authProvider),
            ],
          ),
        ),
      ),
    );
  }
}
