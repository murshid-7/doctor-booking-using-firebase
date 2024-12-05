import 'package:flutter/material.dart';
import 'package:grocery_online_shop/controller/authentication_provider.dart';
import 'package:grocery_online_shop/view/user/authentication/login_type.dart';
import 'package:grocery_online_shop/view/widgets/user_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goToLoginType(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset('assets/img/welcome_doc.jpg'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: size.height * .1),
              child: const CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> goToLoginType(context) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    final userProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    if (currentUser == null) {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginTypeScreen()));
    } else {
      await userProvider.getUser();
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const UserBottomBar()));
    }
  }
}
