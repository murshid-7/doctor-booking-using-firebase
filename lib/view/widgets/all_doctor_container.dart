import 'package:flutter/material.dart';
import 'package:grocery_online_shop/controller/admin_provider.dart';
import 'package:grocery_online_shop/model/doctor_model.dart';
import 'package:grocery_online_shop/view/user/home/doctor_detail_screen.dart';
import 'package:grocery_online_shop/view/widgets/normal_widgets.dart';
import 'package:grocery_online_shop/view/widgets/snackbar_widget.dart';
import 'package:grocery_online_shop/view/widgets/text_widgets.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AllDoctorsContainer extends StatelessWidget {
  final Size size;
  final bool? isAdmin;
  final DoctorProvider value;
  final DoctorModel? doctors;
  final double circleAvatarRadius;

  const AllDoctorsContainer({
    super.key,
    this.isAdmin,
    this.doctors,
    required this.size,
    required this.value,
    required this.circleAvatarRadius,
  });

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<DoctorProvider>(context, listen: false);
    return isAdmin == true
        ? Container(
            height: size.height * .16,
            width: size.width * .93,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              border: Border.all(
                color: const Color(0xFFFFFFFF),
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10, vertical: size.height * .03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                      radius: circleAvatarRadius,
                      backgroundColor: const Color.fromARGB(255, 116, 155, 179),
                      backgroundImage: NetworkImage(doctors!.image!)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        poppinsHeadText(
                          text: 'Dr. ${doctors?.fullName}',
                          color: const Color(0xFF1D1617),
                          fontSize: 14,
                        ),
                        Row(children: [
                          poppinsSmallText(
                            text: '${doctors?.category} | ',
                          ),
                          poppinsSmallText(
                              text: doctors?.position,
                              softWrap: true,
                              maxLine: 1)
                        ]),
                        poppinsSmallText(
                          text: '${doctors?.experience}Yrs Experience',
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      confirmationDialog(
                        context,
                        size,
                        dialogheight: size.height * .12,
                        alertMessage: 'Confirm to delete the doctor',
                        confirmText: 'Delete',
                        onPressedConfirm: () {
                          adminProvider.deleteDoctor(
                            doctors!.id!,
                            (success) {
                              SnackBarWidget()
                                  .showSuccessSnackbar(context, success);
                            },
                          );
                          Navigator.pop(context);
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Color(0xFFF24E1E),
                    ),
                  )
                ],
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DoctorDetailScreen(
                            doctors: doctors,
                            value: value,
                            userId: FirebaseAuth.instance.currentUser!.uid,
                          )));
            },
            child: Container(
              height: size.height * .16,
              width: size.width * .93,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                border: Border.all(
                  color: const Color(0xFFFFFFFF),
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: size.height * .03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                        radius: circleAvatarRadius,
                        backgroundColor:
                            const Color.fromARGB(255, 243, 242, 242),
                        backgroundImage: NetworkImage(doctors!.image!)),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          poppinsHeadText(
                            text: 'Dr. ${doctors?.fullName}',
                            color: const Color(0xFF1D1617),
                            fontSize: 14,
                          ),
                          Row(children: [
                            poppinsSmallText(
                              text: '${doctors?.category} | ',
                            ),
                            poppinsSmallText(
                              text: doctors?.position,
                            )
                          ]),
                          poppinsSmallText(
                              text: '${doctors?.experience} Yrs Experience')
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        final wish = value.wishListCheck(doctors!);
                        value.wishlistClicked(doctors!.id!, wish);
                      },
                      icon: value.wishListCheck(doctors!)
                          ? const Icon(
                              Icons.favorite_border_rounded,
                              size: 30,
                              color: Colors.blue,
                            )
                          : const Icon(
                              Icons.favorite_rounded,
                              size: 30,
                              color: Colors.blue,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
