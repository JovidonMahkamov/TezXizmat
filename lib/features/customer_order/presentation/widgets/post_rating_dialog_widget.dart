import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/customer_order_event.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/confirm_completion_order/confirm_completion_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/confirm_completion_order/confirm_completion_state.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/post_reviews/post_reviews_bloc.dart';
import 'package:tez_xizmat/features/customer_order/presentation/bloc/post_reviews/post_reviews_state.dart';

class PostRatingDialogWidget extends StatefulWidget {
  final int orderId;
  final BuildContext pageContext;

  const PostRatingDialogWidget({
    super.key,
    required this.orderId,
    required this.pageContext,
  });

  @override
  State<PostRatingDialogWidget> createState() => RatingDialogState();
}

class RatingDialogState extends State<PostRatingDialogWidget> {
  int _rating = 0;
  final _controller = TextEditingController();

  bool _confirmStarted = false;
  bool _shouldSendReview = false;

  void _closeDialogAndPopPage() {
    // 1) dialogni yopadi
    Navigator.of(widget.pageContext, rootNavigator: true).pop();

    // 2) OrderViewPage’ni yopadi (orqaga qaytadi)
    Navigator.of(widget.pageContext).pop();
  }

  void _submit() {
    final comment = _controller.text.trim();
    _shouldSendReview = (_rating != 0) || comment.isNotEmpty;

    setState(() => _confirmStarted = true);

    // 1-qadam: avval confirm completion
    context.read<ConfirmCompletionBloc>().add(
      ConfirmCompletionE(id: widget.orderId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        //  Confirm listener
        BlocListener<ConfirmCompletionBloc, ConfirmCompletionState>(
          listener: (context, state) {
            if (!_confirmStarted) return;

            if (state is ConfirmCompletionError) {
              setState(() => _confirmStarted = false);
              ScaffoldMessenger.of(widget.pageContext).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }

            if (state is ConfirmCompletionSuccess) {
              if (_shouldSendReview) {
                final comment = _controller.text.trim();
                context.read<PostReviewsBloc>().add(
                  PostReviewsE(
                    orderId: widget.orderId,
                    stars: _rating == 0 ? 1 : _rating,
                    text: comment,
                  ),
                );
              } else {
                _closeDialogAndPopPage();
              }
            }
          },
        ),

        BlocListener<PostReviewsBloc, PostReviewsState>(
          listener: (context, state) {
            if (state is PostReviewsSuccess) {
              _closeDialogAndPopPage();
            }

            if (state is PostReviewsError) {
              // Review optional — xato bo‘lsa ham confirm bo‘ldi,
              // shuning uchun xabar ko‘rsatib, baribir yopamiz (talabinggizga mos)
              ScaffoldMessenger.of(widget.pageContext).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              _closeDialogAndPopPage();
            }
          },
        ),
      ],
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Ushbu xodim ko‘rsatgan xizmatdan \n umumiy tajribangizni qanday \n baholaysiz?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final i = index + 1;
                  return IconButton(
                    onPressed: () {
                      setState(() => _rating = _rating == i ? 0 : i);
                    },
                    icon: Icon(
                      _rating >= i ? Icons.star : Icons.star_border,
                      color: Colors.orangeAccent,
                      size: 40,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Xodim haqida fikringizni yozib qoldiring",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Fikr bildiring ...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              const Text(
                "Agar ish to‘liq bajarilgan bo‘lsa, tasdiqlang. Tasdiqlashdan so‘ng buyurtma yopiladi.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
              ),

              const SizedBox(height: 16),

              Builder(
                builder: (context) {
                  final confirmLoading =
                  context.watch<ConfirmCompletionBloc>().state is ConfirmCompletionLoading;
                  final reviewLoading =
                  context.watch<PostReviewsBloc>().state is PostReviewsLoading;

                  final isLoading = confirmLoading || reviewLoading;

                  return SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        "Ha, yakunlandi",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
