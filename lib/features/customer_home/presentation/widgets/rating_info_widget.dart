import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/get_worker_reviews/get_worker_reviews_bloc.dart';
import '../bloc/get_worker_reviews/get_worker_reviews_state.dart';
import '../../domain/entities/get_worker_reviews_entity.dart';

class RatingSheetBody extends StatelessWidget {
  const RatingSheetBody({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<GetWorkerReviewsBloc, GetWorkerReviewsState>(
            builder: (context, state) {
              if (state is GetWorkerReviewsInitial ||
                  state is GetWorkerReviewsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GetWorkerReviewsError) {
                return Center(child: Text(state.message));
              }

              if (state is GetWorkerReviewsSuccess) {
                final reviews = state.getWorkerReviewsEntity;

                if (reviews.isEmpty) {
                  return const Center(
                    child: Text(
                      "Hali sharhlar yo‘q",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return _WorkerReviewsList(
                  reviews: reviews,
                  scrollController: scrollController,
                );
              }

              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}

class _WorkerReviewsList extends StatelessWidget {
  final List<GetWorkerReviewsEntity> reviews;
  final ScrollController scrollController;

  const _WorkerReviewsList({
    required this.reviews,
    required this.scrollController,
  });

  String _formatDate(String iso) {
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(iso));
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      itemCount: reviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, i) {
        final r = reviews[i];

        final customer = r.customer; // Map<String, dynamic> bo‘lsa
        final customerName = customer == null
            ? ''
            : "${customer['first_name'] ?? ''} ${customer['last_name'] ?? ''}".trim();

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                blurRadius: 12,
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
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    r.stars.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(r.createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (customerName.isNotEmpty)
                Text(
                  customerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              const SizedBox(height: 6),
              Text(
                r.text,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
            ],
          ),
        );
      },
    );
  }
}
