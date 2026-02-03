import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';

class OrderContainerWidget extends StatelessWidget {
  final String name;
  final String description;
  final String time;
  final String statusText;
  final Color statusColor;
  final String? imageUrl;
  final VoidCallback onViewTap;
  final VoidCallback onChatTap;

  const OrderContainerWidget({
    super.key,
    required this.name,
    required this.description,
    required this.time,
    required this.statusText,
    required this.statusColor,
    required this.imageUrl,
    required this.onViewTap,
    required this.onChatTap,
  });

  ImageProvider _avatarProvider() {
    if (imageUrl == null || imageUrl!.trim().isEmpty || imageUrl == 'null') {
      return const AssetImage("assets/circular_avatar/profile.png");
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
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(child: CircleAvatar(radius: 30, backgroundImage: _avatarProvider())),
                const SizedBox(width: 12),
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
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                          ),
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
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedWidget(
                    onPressed: onViewTap,
                    text: "Ko‘rish",
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: onChatTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgPicture.asset(
                      "assets/bottom_nav_bar/chat.svg",
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}