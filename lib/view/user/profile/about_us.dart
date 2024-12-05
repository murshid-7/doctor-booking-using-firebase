import 'package:flutter/material.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
       
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * .03, vertical: size.height * .02),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              poppinsHeadText(text: 'About Us', fontSize: 20),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 8,
              ),
            ]),
          ),
        ));
  }
}
