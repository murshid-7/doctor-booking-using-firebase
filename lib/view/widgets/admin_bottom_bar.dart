import 'package:flutter/material.dart';
import 'package:grocery_online_shop/controller/bottom_bar_provider.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

class AdminBottomBar extends StatelessWidget {
  const AdminBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 240, 242),
      body: Consumer<BottomProvider>(
          builder: (context, value, child) =>
              value.adminScreens[value.adminCurrentIndex]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 238, 240, 242),
          ),
          height: size.height * .09,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Consumer<BottomProvider>(
              builder: (context, value, child) => BottomNavigationBar(
                unselectedFontSize: 11,
                selectedFontSize: 12,
                type: BottomNavigationBarType.fixed,
                onTap: value.adminOnTap,
                backgroundColor: const Color(0xFFFFFFFF),
                currentIndex: value.adminCurrentIndex,
                selectedItemColor: Colors.blue,
                unselectedItemColor: const Color(0xFF98A3B3),
                showUnselectedLabels: true,
                items: [
                  BottomNavigationBarItem(
                    icon: value.adminCurrentIndex == 0
                        ? Icon(Icons.home, size: 25, color: Colors.blue)
                        : Icon(Icons.home_outlined,
                            size: 25, color: const Color(0xFF98A3B3)),
                    label: poppinsText(
                      text: 'Home',
                      color: const Color(0xFF98A3B3),
                      fontWeight: FontWeight.bold,
                    ).data,
                  ),
                  BottomNavigationBarItem(
                    icon: value.adminCurrentIndex == 1
                        ? Icon(Icons.add_circle, size: 25, color: Colors.blue)
                        : Icon(Icons.add_circle_outline,
                            size: 25, color: const Color(0xFF98A3B3)),
                    label: poppinsText(
                      text: 'Add',
                      color: const Color(0xFF98A3B3),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ).data,
                  ),
                  BottomNavigationBarItem(
                    icon: value.adminCurrentIndex == 2
                        ? Icon(Icons.person, size: 25, color: Colors.blue)
                        : Icon(Icons.person_outline,
                            size: 25, color: const Color(0xFF98A3B3)),
                    label: poppinsText(
                      text: 'Profile',
                      color: const Color(0xFF98A3B3),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ).data,
                  ),
                  BottomNavigationBarItem(
                    icon: value.adminCurrentIndex == 3
                        ? Icon(Icons.book, size: 25, color: Colors.blue)
                        : Icon(Icons.book_rounded,
                            size: 25, color: const Color(0xFF98A3B3)),
                    label: poppinsText(
                      text: 'Bookings',
                      color: const Color(0xFF98A3B3),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ).data,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
