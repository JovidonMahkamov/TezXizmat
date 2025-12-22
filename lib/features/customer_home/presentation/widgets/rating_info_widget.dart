import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';

void showRatingSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // yuqoriga ham siljishi uchun
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        // boshlang'ich balandlik
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Reyting va sharhlar',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Text(
                      '4.4',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.star, color: Colors.amber, size: 36),
                    SizedBox(width: 8),
                    Text(
                      '923 ta baho va 257 ta sharh',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 10, // sharhlar soni
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.star, color: Colors.amber, size: 20),
                                SizedBox(width: 4),
                                Text(
                                  '5.0',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff4D4D4D),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '12-dec-2025',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Sevinch Sharobidinova',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            ReadMoreText(
                              'Jovidon juda tajribali santexnik ekan. Kran oqayotgan edi, hammasini tez va chiroyli qilib tuzatdi. Ishidan juda mamnunman.',
                              trimLines: 1,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: " Read more",
                              trimExpandedText: " Read less",
                              style: TextStyle(fontSize: 14.sp),
                              moreStyle: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                              lessStyle: TextStyle(
                                color: Color(0xff1778F2),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(child: Divider()),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
