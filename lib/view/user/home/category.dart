import 'package:flutter/material.dart';
import 'package:grocery_online_shop/controller/admin_provider.dart';
import 'package:grocery_online_shop/controller/bottom_bar_provider.dart';
import 'package:grocery_online_shop/view/widgets/all_doctor_container.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';
import 'package:provider/provider.dart';


const double circleAvatarRadiusFraction = 0.1;

class CategoryScreen extends StatelessWidget {
  final String category;
  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    if (category == "More") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<BottomProvider>(context, listen: false).userOnTap(2);
        Navigator.pop(context);
      });
      return Container();
    }

    Size size = MediaQuery.of(context).size;
    double circleAvatarRadius = size.shortestSide * circleAvatarRadiusFraction;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
        backgroundColor: const Color(0xFFF5F5F5),
        title: poppinsText(
            text: category,
            color: const Color(0xFF1A1A1A),
            fontSize: 20,
            fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Consumer<DoctorProvider>(
          builder: (context, doctorValue, child) {
            final filteredDoctors = doctorValue.allDoctorList
                .where((doctors) => doctors.category == category)
                .toList();

            return filteredDoctors.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctors = filteredDoctors[index];
                      return Column(
                        children: [
                          AllDoctorsContainer(
                              size: size,
                              isAdmin: false,
                              doctors: doctors,
                              value: doctorValue,
                              circleAvatarRadius: circleAvatarRadius),
                          SizedBox(height: size.height * .02),
                        ],
                      );
                    },
                  )
                : Text('no doctors available now');
          },
        ),
      ),
    );
  }
}
