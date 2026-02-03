import 'package:flutter/material.dart';
import 'package:tez_xizmat/features/worker_profile/presentation/widgets/my_reviews_sheet_widget.dart';

class RatingSheetBodyTwo extends StatelessWidget {
  const RatingSheetBodyTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ReviewsContentTwo(
            scrollController: scrollController,
          ),
        );
      },
    );
  }
}
