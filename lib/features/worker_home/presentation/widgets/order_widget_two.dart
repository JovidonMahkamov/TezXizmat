import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'order_image_view.dart';


class OrderWidgetTwo extends StatelessWidget {
  final String name;
  final String description;
  final String time;
  final String statusText;
  final Color statusColor;
  final String imageUrl;
  final ImageProvider backgroundImage;
  final int orderId;



  const OrderWidgetTwo({
    super.key,
    required this.name,
    required this.description,
    required this.time,
    required this.statusText,
    required this.statusColor,
    required this.imageUrl,
    required this.backgroundImage,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final heroTag = 'order-avatar-${orderId}';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (_, __, ___) => OrderImageView(
                          heroTag: heroTag,
                          image: backgroundImage,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: heroTag,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: backgroundImage,
                    ),
                  ),
                ),                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(time, style: const TextStyle(fontSize: 14)),
                          const Spacer(),
                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h,),
            Container(
              width: double.infinity,
              height: 40.h,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}