import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/get_worker_reviews/get_worker_reviews_bloc.dart';
import '../bloc/get_worker_reviews/get_worker_reviews_state.dart';

class ReviewsContent extends StatelessWidget {
  const ReviewsContent({super.key, required ScrollController scrollController});
  String formatDateTime(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate).toLocal();
      return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
    } catch (e) {
      return isoDate; // xato bo‘lsa eski holicha
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetWorkerReviewsBloc, GetWorkerReviewsState>(
      builder: (context, state) {
        if (state is GetWorkerReviewsLoading) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is GetWorkerReviewsError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                state.message,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (state is GetWorkerReviewsSuccess) {
          final list = state.getWorkerReviewsEntity;

          if (list.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Text("Hali sharhlar yo‘q.")),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final r = list[index];

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                      color: Colors.black.withOpacity(0.06),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 6),
                        Text(
                          "${r.stars}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          formatDateTime(r.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      r.text,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text(
              "Sharhlarni ko‘rish uchun chaqiring.",
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}