import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesFieldsWidget extends StatefulWidget {
  const ServicesFieldsWidget({super.key});

  @override
  State<ServicesFieldsWidget> createState() => _ServicesFieldsWidgetState();
}

class _ServicesFieldsWidgetState extends State<ServicesFieldsWidget> {
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    controllers.add(TextEditingController());
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: List.generate(controllers.length, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controllers[index],
                      decoration: InputDecoration(
                        hintText: "Xizmat nomi",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 14.h),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: Color(0xffE5E7EB),
                            width: 1.w,
                          ),
                      ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: Colors.blueAccent,
                            width: 1.w,
                          ),),
                    ),
                  ),),
                  SizedBox(width: 8.w),
                  InkWell(
                    onTap: () {
                      setState(() {
                        controllers.add(TextEditingController());
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
        )
      ],
    );
  }
}
