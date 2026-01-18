import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';

class WorkerLogOutWidget extends StatefulWidget {
  const WorkerLogOutWidget({super.key});

  @override
  State<WorkerLogOutWidget> createState() => _WorkerLogOutWidgetState();
}

class _WorkerLogOutWidgetState extends State<WorkerLogOutWidget> {
  bool _isLoading = false;

  Future<void> _logout() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final box = await Hive.openBox('authBox');

      //  tokenlarni o'chiramiz
      await box.delete('accessToken');
      await box.delete('refreshToken');

      // xohlasang remember me ham o'chir:
      // await box.delete('email');
      // await box.delete('password');

      if (!mounted) return;

      Navigator.of(context).pop(); // dialogni yopish

      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.customerRegister,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Logout xatolik: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 30,
          bottom: 30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Akkauntdan chiqishni xohlaysizmi?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      child: Center(
                        child: Text(
                          "Yo'q",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: SizedBox(
                    height: 46.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: _isLoading ? null : _logout,
                      child: Center(
                        child: Text(
                          _isLoading ? "..." : "Ha",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
