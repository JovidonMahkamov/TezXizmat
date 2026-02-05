import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../worker_home/presentation/widgets/order_image_view.dart';

class OrderContainerWidgetTwo extends StatelessWidget {
  final String name;
  final String description;
  final String time;
  final String statusText;
  final Color statusColor;
  final String? imageUrl;
  final String heroTag;


  const OrderContainerWidgetTwo({
    super.key,
    required this.name,
    required this.description,
    required this.time,
    required this.statusText,
    required this.statusColor,
    required this.imageUrl,
    required this.heroTag,

  });

  ImageProvider _avatarProvider() {
    if (imageUrl == null || imageUrl!.trim().isEmpty || imageUrl == 'null') {
      return const AssetImage("assets/profile/per.png");
    }
    return NetworkImage(imageUrl!);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                final img = _avatarProvider();

                Navigator.push(
                  context,
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (_, __, ___) => OrderImageView(
                      heroTag: heroTag,
                      image: img,
                    ),
                  ),
                );
              },
              child: Hero(
                tag: heroTag,
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: _avatarProvider(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(time, style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
