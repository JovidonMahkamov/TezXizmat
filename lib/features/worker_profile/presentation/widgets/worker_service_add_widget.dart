import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesFieldsWidget extends StatefulWidget {
  final ValueChanged<List<String>> onChanged;

  // yangi: editga kirganda eski skill/service larni chiqarish uchun
  final List<String>? initialValues;

  const ServicesFieldsWidget({
    super.key,
    required this.onChanged,
    this.initialValues,
  });

  @override
  State<ServicesFieldsWidget> createState() => _ServicesFieldsWidgetState();
}

class _ServicesFieldsWidgetState extends State<ServicesFieldsWidget> {
  final List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();

    final init = widget.initialValues ?? [];

    if (init.isNotEmpty) {
      for (final t in init) {
        controllers.add(TextEditingController(text: t));
      }
    } else {
      controllers.add(TextEditingController());
    }

    // birinchi marta parentga ham jo‘natib qo‘yamiz
    WidgetsBinding.instance.addPostFrameCallback((_) => _notify());
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _notify() {
    final list = controllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    widget.onChanged(list);
  }

  void _addField() {
    setState(() {
      controllers.add(TextEditingController());
    });
    _notify();
  }

  void _removeField(int index) {
    if (controllers.length <= 1) return;

    setState(() {
      final removed = controllers.removeAt(index);
      removed.dispose();
    });
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(controllers.length, (index) {
        final canRemove = controllers.length > 1;

        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controllers[index],
                  onChanged: (_) => _notify(),
                  decoration: InputDecoration(
                    hintText: "Xizmat nomi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),

              if (canRemove)
                InkWell(
                  onTap: () => _removeField(index),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.remove, color: Colors.white),
                  ),
                ),

              if (canRemove) SizedBox(width: 8.w),

              InkWell(
                onTap: _addField,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
