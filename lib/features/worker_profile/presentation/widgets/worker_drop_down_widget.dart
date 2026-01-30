import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class CustomDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;


  const CustomDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> items = [
      'Elektrik',
      'Santexnik',
      'Konditsioner ustasi',
      'Uy tozalovchi',
      'Usta',
      'Kafelchi',
      'Malyar',
      'Gipsokartonchi',
      'Eshik-deraza ustasi',
      'Konditsioner ustasi',
      'Maishiy texnika ustasi',
      'Mebel ustasi',
      'Tom ustasi',
      'Bog‘bon',
      'Qo‘riqchi',
      'Boshqa',
    ];
    final String? safeValue = items.contains(value) ? value : null;

    return DropdownButtonHideUnderline(
      child: Container(
        height: 58.h,
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            'Ish turini tanlang',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xFF9296A6),
            ),
          ),
          items: items.map((String item) {
            final bool isSelected = value == item;
            return DropdownMenuItem<String>(
              value: item,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade50 : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.blue : Colors.black87,
                  ),
                ),
              ),
            );
          }).toList(),
          value: safeValue,
          onChanged: onChanged, // eng muhim joy
          buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade100,
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(height: 50),
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down_rounded),
            iconSize: 24,
            iconEnabledColor: Colors.grey,
            iconDisabledColor: Colors.grey,
          ),
        ),
      ),
    );
  }
}

