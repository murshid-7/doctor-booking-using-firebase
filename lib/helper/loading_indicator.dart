import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


Shimmer loadingIndicator(Size size, {circleWidth, circleHeight}) {
  return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: circleHeight,
                  width: circleWidth,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 16,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 16,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 16,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                )
              ],
            )
          ],
        ),
      ));
}

String generateChatRoomId({
  required String uId1,
  required String uId2,
}) {
  List<String> uIds = [uId1, uId2];
  uIds.sort();
  String chatId = uIds.join();
  return chatId;
}
