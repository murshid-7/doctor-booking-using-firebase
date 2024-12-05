import 'package:flutter/material.dart';
import 'package:grocery_online_shop/controller/bottom_bar_provider.dart';
import 'package:grocery_online_shop/view/user/authentication/login_type.dart';
import 'package:provider/provider.dart';

const double circleAvatarRadiusFraction = 0.18;

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double circleAvatarRadius = size.shortestSide * circleAvatarRadiusFraction;
    final bottomProvider = Provider.of<BottomProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.blue[50], 
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        title: Text(
          'Admin Profile',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 22, color: Colors.blue),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: circleAvatarRadius,
              backgroundColor: Colors.grey,
              backgroundImage: const AssetImage('assets/images/default_profile.png'),
            ),
            SizedBox(height: size.height * .02),
            profileScreenContainer(
              context,
              containerHeight: size.height * .30,
              containerWidth: size.width * .90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('John Doe', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                  SizedBox(height: 10),
                  Text('Administrator', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      confirmationDialog(context, size,
                        alertMessage: 'Are you sure you want to log out?',
                        confirmText: 'Log Out',
                        onPressedConfirm: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginTypeScreen()), (route) => false);
                          bottomProvider.adminOnTap(0);
                          bottomProvider.userOnTap(0);
                        });
                    },
                    child: Text('Log Out', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget profileScreenContainer(BuildContext context, {required double containerHeight, required double containerWidth, required Widget child}) {
  return Container(
    height: containerHeight,
    width: containerWidth,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 5)),
      ],
    ),
    child: child,
  );
}

void confirmationDialog(BuildContext context, Size size, {required String alertMessage, required String confirmText, required VoidCallback onPressedConfirm}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirmation', style: TextStyle(fontWeight: FontWeight.bold)),
      content: Text(alertMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: onPressedConfirm,
          child: Text(confirmText),
        ),
      ],
    ),
  );
}
