import 'package:flutter/material.dart';
import 'package:grocery_online_shop/controller/authentication_provider.dart';
import 'package:grocery_online_shop/controller/bottom_bar_provider.dart';
import 'package:grocery_online_shop/view/user/authentication/login_type.dart';
import 'package:grocery_online_shop/view/user/profile/widget_profile.dart';
import 'package:grocery_online_shop/view/widgets/normal_widgets.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


const double circleAvatarRadiusFraction = 0.15;

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double circleAvatarRadius = size.shortestSide * circleAvatarRadiusFraction;
    final bottomProvider = Provider.of<BottomProvider>(context, listen: false);
    final authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    final firebaseauth = FirebaseAuth.instance.currentUser;
    ImageProvider? imageProvider;
    if (firebaseauth != null && firebaseauth.photoURL != null) {
      imageProvider = NetworkImage(firebaseauth.photoURL.toString());
    } else {
      imageProvider = const AssetImage("assets/avatar-removebg-preview.png");
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
      body: Padding(
        padding: EdgeInsets.fromLTRB(size.width * .03, size.height * 0.1,
            size.width * .03, size.height * 0.05),
        child:
            Consumer<AuthenticationProvider>(builder: (context, value, child) {
          return Column(
            children: [
              CircleAvatar(
                radius: circleAvatarRadius,
                backgroundColor: const Color.fromARGB(255, 143, 189, 198),
                backgroundImage: value.currentUser?.image != null
                    ? NetworkImage(value.currentUser!.image!)
                    : imageProvider,
              ),
              SizedBox(width: size.width * .02),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    poppinsHeadText(
                      text: value.currentUser?.userName ?? 'Unknown',
                      color: const Color(0xFF1D1617),
                      fontSize: 15,
                    ),
                    SizedBox(height: size.height * .008),
                    poppinsHeadText(
                      text: value.currentUser?.email ?? firebaseauth?.email,
                      fontSize: 15,
                      color: const Color(0xFF888888),
                    ),
                  ]),
              SizedBox(height: size.height * .025),
              userProfileScreenContainer(size, context,
                  height: size.height * .173,
                  width: size.width * .9,
                  sizedBoxWidth: size.width * .02,
                  value: value,
                  imageProvider: imageProvider),
              SizedBox(height: size.height * .03),
              Expanded(
                child: profileScreenContainer(
                  context,
                  containerHeight: size.height * .1,
                  containerWidth: size.width * .9,
                  isAdmin: false,
                  onTap: () {
                    confirmationDialog(context, size,
                        dialogWidth: size.width * .2,
                        height: size.height * .015,
                        alertMessage: 'Are you sure to Log out ?',
                        confirmText: 'Log Out', onPressedConfirm: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginTypeScreen()),
                          (route) => false);
                      bottomProvider.adminOnTap(0);
                      bottomProvider.userOnTap(0);
                      authenticationProvider.logOut();
                      authenticationProvider.googleSignOut();
                    });
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
