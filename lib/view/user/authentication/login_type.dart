import 'package:flutter/material.dart';
import 'package:grocery_online_shop/view/user/authentication/create_account.dart';
import 'package:grocery_online_shop/view/user/authentication/sign_in.dart';

class LoginTypeScreen extends StatelessWidget {
  const LoginTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30), 
            ),
            child: Image.asset(
              'assets/img/welcome_doc.jpg',
              fit: BoxFit.cover,
              height: size.height * 0.4,
              width: double.infinity,
            ),
          ),
          SizedBox(height: size.height * 0.08),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Welcome to Our Health App!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Your health is our priority. Join us to schedule appointments with the best healthcare providers easily and conveniently.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey, 
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: size.height * 0.05),
      
          SizedBox(
            width: size.width * 0.8,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'CREATE ACCOUNT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateAccountScreen(),
                  ),
                );
              },
            ),
          ),
      
          SizedBox(height: size.height * 0.02),
      
          SizedBox(
            width: size.width * 0.8,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'SIGN IN',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInScreen(),
                  ),
                );
              },
            ),
          ),
      
          SizedBox(height: size.height * 0.05),
        ],
      ),
    );
  }
}
