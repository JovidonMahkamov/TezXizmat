import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/reviewscontent.dart';

import '../bloc/get_worker_reviews/get_worker_reviews_bloc.dart';
import '../bloc/get_worker_reviews/get_worker_reviews_state.dart';

class RatingSheetBody extends StatelessWidget {
  const RatingSheetBody();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: BlocBuilder<GetWorkerReviewsBloc, GetWorkerReviewsState>(
            builder: (context, state) {
              if (state is GetWorkerReviewsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GetWorkerReviewsError) {
                return Center(child: Text(state.message));
              }

              if (state is GetWorkerReviewsSuccess) {
                return ReviewsContent(
                );
              }

              return const SizedBox();
            },
          ),
        );
      },
    );
  }
}
