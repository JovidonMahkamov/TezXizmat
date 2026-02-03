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
      'Divan, kreslo va stol yuvish',
      'Deraza yuvish',
      'Baland binolar derazasini yuvish',
      'Ofis, korxona tozalovchi',
      'Gilam, palos yuvish',
      'Uy, ofislarni dorilash',
      'Ximchistka',
      'Parda yuvish',
      'Kiyim dazmol qiluvchi',
      'Quyosh paneli tozalovchi',
      'Yuk tashuvchi (inson)',
      'Yuk tashuvchi transport',
      'Shaharlararo yo’lovchi tashish',
      'Shaharlararo yuk tashish',
      'Ombor (sklad) xizmatlari',
      'Uy anjomlarini omborda saqlash',
      'Ijaraga haydovchi (mashinasiz)',
      'Ijaraga haydovchi (mashinasi bilan)',
      'Xalqaro logistika',
      'Radiator tozalash',
      'Kotyol (qozon) o’rnatish',
      'Payvandchi (svarshik)',
      'Kamera o’rnatish ustasi',
      'Avtomobil ta’miri ustasi',
      'Chevrolet ustasi',
      'Isuzu ustasi',
      'BYD ustasi',
      'Kia ustasi',
      'Hyundai ustasi',
      'Zeekr ustasi',
      'Asfalt qilish xizmati',
      'Online Ingliz tili',
      'Online Rus tili',
      'Online Koreys tili',
      'Online Nemis tili',
      'Matematika',
      'Fizika',
      'Biologiya',
      'Kimyo',
      'Turk tili',
      'Ayollar uchun mashina haydash o’qituvchisi',
      'Tarix',
      'Tennis o’qituvchisi',
      'Suzish o’qituvchisi',
      'Bolalar uchun suzish o’qituvchisi',
      'Kattalar uchun suzish o’qituvchisi',
      'Ayollar uchun suzish o’qituvchisi',
      'Shaxmat o’qituvchisi',
      'Yoga o’qituvchisi',
      'Gitara o’qituvchisi',
      'Pianino o’qituvchisi',
      'Musiqa o’qituvchisi',
      'Rubob, tor o’qituvchisi',
      'Klarnet, nay o’qituvchisi',
      'Skripka o’qituvchisi',
      'Enaga (bolalar uchun)',
      'Psixolog',
      'Online psixolog',
      'Bolalar psixologi',
      'Pedagog',
      'Diyetolog',
      'Fitness trener',
      'Shaxsiy fitness treneri',
      'Fizioterapist',
      'Xamshira',
      'Kattalar uchun xamshira',
      'Yoga darsi',
      'Pilates darsi',
      'Ayollar go’zallik xizmatlari',
      'Uyingizda ayollar go’zallik xizmatlari',
      'Makiyaj',
      'Parikmaxer',
      'Makyaj va parikmaxer',
      'Massaj',
      'Ayollar uchun massaj',
      'Erkaklar uchun massaj',
      'Chaqaloq uchun massaj',
      'Chevar',
      'Ayollar chevari',
      'Erkaklar chevari',
      'Qariyalar uchun enaga',
      'Uy xizmatchisi',
      'Pardachi',
      'Qassob',
      'Web-site yaratuvchi',
      'Kompyuter programmisti',
      'Marketdan uyga yetkazib berish xizmati',
      'Bozordan uyga yetkazib berish xizmati',
      'Catering xizmati',
      'To’y marosimlari tashkil qilish',
      'Marosimlar uchun san’atkor (qushiqchi, raqs guruhi va hk.)',
      'Oshpaz',
      'Milliy taomlar oshpazi',
      'Chet el taomlari oshpazi',
      'Yevropa taomlari oshpazi',
      'Xitoy taomlari oshpazi',
      'Turk taomlari oshpazi',
      'Ofitsiant',
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

