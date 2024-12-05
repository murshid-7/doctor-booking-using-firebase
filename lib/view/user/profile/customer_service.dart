import 'package:flutter/material.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';

class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 238, 240, 242),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 238, 240, 242),
          title: poppinsText(
              text: '',
              color: const Color(0xFF1A1A1A),
              fontSize: 25,
              fontWeight: FontWeight.bold),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * .03, vertical: size.height * .02),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              poppinsHeadText(text: 'Customer Service', fontSize: 20),
              const SizedBox(
                height: 10,
              ),
              poppinsText(text: '', fontWeight: FontWeight.w600),
              const SizedBox(
                height: 20,
              ),
              poppinsHeadText(text: 'How Can We Help You?', fontSize: 20),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 8,
              ),
              const SizedBox(
                height: 10,
              ),
              poppinsHeadText(text: 'Technical Support:'),
              const SizedBox(
                height: 8,
              ),
              poppinsText(
                  text:
                      'Encountering technical difficulties? Our technical support team is ready to assist you with troubleshooting and resolving any issues you might face while using the app.',
                  fontWeight: FontWeight.w600),
              const SizedBox(
                height: 10,
              ),
              poppinsHeadText(text: 'Billing and Payments:'),
              const SizedBox(
                height: 8,
              ),
              poppinsHeadText(text: 'Contact Us', fontSize: 20),
              const SizedBox(
                height: 10,
              ),
              poppinsHeadText(text: 'Email Support:'),
              const SizedBox(
                height: 8,
              ),
              const SizedBox(
                height: 20,
              ),
              poppinsHeadText(text: 'Your Satisfaction Matters', fontSize: 20),
              const SizedBox(
                height: 10,
              ),
           
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 20,
              ),
            ]),
          ),
        ));
  }
}
