import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/put_orders_state/put_orders_state_bloc.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/put_orders_state/put_orders_state.dart';
import 'package:tez_xizmat/features/worker_home/presentation/bloc/worker_home_event.dart';
import '../../domain/entities/put_orders_state_entity.dart';
import '../bloc/get_staff_orders/get_staff_orders_bloc.dart';

void customerShowInfoWidget(BuildContext context, {required PutOrdersStateEntity order}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Mijozning ma’lumotlari",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close_outlined),
                    ),
                  ],
                ),
                SizedBox(child: Divider()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6.h,),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Ism: ",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: order.customer.firstName,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 6.h,),
                    SizedBox(child: Divider(),),
                    SizedBox(height: 6.h,),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Familiya: ",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: order.customer.lastName,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 6.h,),
                    SizedBox(child: Divider(),),
                    SizedBox(height: 6.h,),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Manzil: ",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: order.address,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 6.h,),
                    SizedBox(child: Divider(),),
                    SizedBox(height: 6.h,),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Batafsil: ",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text:
                                order.description,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 6.h,),
                    SizedBox(child: Divider(),),
                  ],
                ),
                SizedBox(height: 30.h),
                BlocConsumer<PutStaffOrderBloc, PutOrdersState>(
                  listener: (context, state) {
                    if (state is PutOrdersStateSuccess) {
                      Navigator.pop(context);

                      // SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Amal muvaffaqiyatli bajarildi ✅")),
                      );

                      context.read<GetStaffOrdersBloc>().add(const GetStaffOrdersE());
                    }

                    if (state is PutOrdersStateError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is PutOrdersStateLoading;
                    final st = order.status.toUpperCase();

                    final isPending = st == "PENDING";
                    final isAcceptedOrProgress = st == "ACCEPTED" || st == "IN_PROGRESS";

                    void doAccept() {
                      if (isLoading) return;
                      context.read<PutStaffOrderBloc>().add(AcceptStaffOrderE(order.id));
                    }

                    void doCancel() {
                      if (isLoading) return;
                      context.read<PutStaffOrderBloc>().add(CancelStaffOrderE(order.id));
                    }

                    void doComplete() {
                      if (isLoading) return;
                      context.read<PutStaffOrderBloc>().add(CompleteStaffOrderE(order.id));
                    }

                    void doStart() {
                      if (isLoading) return;
                      context.read<PutStaffOrderBloc>().add(StartStaffOrderE(order.id));
                    }

                    if (isPending) {
                      return Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 46.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                                onPressed:isLoading ? null : doCancel,
                                child:  Center(
                                  child: Text(
                                    isLoading ? "..." : "Bekor qilish",
                                    style: TextStyle (color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child:SizedBox(
                              height: 46.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed:isLoading ? null : doAccept,
                                child:  Center(
                                  child: Text(
                                    isLoading ? "..." : "Qabul qilish",
                                    style: TextStyle (color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    if (isAcceptedOrProgress) {
                      return Row(
                        children: [
                          Expanded(
                            child:SizedBox(
                              height: 46.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed:isLoading ? null : doStart,
                                child:  Center(
                                  child: Text(
                                    isLoading ? "..." : "Ishni boshlash",
                                    style: TextStyle (color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedWidget(
                        onPressed: () => Navigator.pop(context),
                        text: "Yopish",
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
