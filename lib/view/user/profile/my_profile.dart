// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_online_shop/controller/authentication_provider.dart';
import 'package:grocery_online_shop/view/user/profile/edit_profile.dart';
import 'package:grocery_online_shop/view/user/profile/widget_profile.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';


const double circleAvatarRadiusFraction = 0.18;

class ProfileDetailsScreen extends StatelessWidget {
  final AuthenticationProvider value;
  final imageProvider;
  const ProfileDetailsScreen({
    super.key,
    required this.value,
    this.imageProvider,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double circleAvatarRadius = size.shortestSide * circleAvatarRadiusFraction;
    final firebaseauth = FirebaseAuth.instance.currentUser;
    final effectiveImageProvider = imageProvider;

    return Scaffold(
      backgroundColor: const Color.fromARGB(237, 255, 255, 255),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: size.height * .07, horizontal: size.width * .015),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  SizedBox(
                    height: size.height * .041,
                    width: size.width * .2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileEditScreen(
                                      value: value,
                                      user: value.currentUser!,
                                      imageProvider: effectiveImageProvider,
                                    )));
                      },
                      child: poppinsText(
                        text: 'Edit',
                        textAlign: TextAlign.center,
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * .075),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        radius: circleAvatarRadius,
                        backgroundColor:
                            const Color.fromARGB(255, 143, 189, 198),
                        backgroundImage: value.currentUser?.image != null
                            ? NetworkImage(value.currentUser?.image ?? '')
                            : effectiveImageProvider),
                    SizedBox(height: size.height * .02),
                    userProfileDetailsListTile(context,
                        titleText: 'USER',
                        valueText: value.currentUser?.userName ?? ''),
                    SizedBox(
                      height: size.height * .02,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: userProfileDetailsListTile(context,
                              titleText: 'AGE',
                              valueText: value.currentUser?.age ?? ''),
                        ),
                        SizedBox(
                          width: size.width * .1,
                        ),
                        Flexible(
                          child: userProfileDetailsListTile(context,
                              titleText: 'GENDER',
                              valueText: value.currentUser?.gender ?? ''),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * .02,
                    ),
                    userProfileDetailsListTile(context,
                        titleText: 'PHONE',
                        valueText: '+91 ${value.currentUser?.phoneNumber}'),
                    SizedBox(
                      height: size.height * .02,
                    ),
                    userProfileDetailsListTile(
                      context,
                      titleText: 'EMAIL',
                      valueText:
                          value.currentUser?.email ?? firebaseauth!.email,
                    ),
                    SizedBox(
                      height: size.height * .02,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
