import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget.dart';
import 'package:tez_xizmat/features/customer_home/presentation/widgets/home_container_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Qidiruv",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            TextFieldWidget(
              controller: textEditingController,
              text: "Qidiruv",
              obscureText: false,
              suffixIcon: textEditingController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        textEditingController
                            .clear();
                        setState(() {});
                      },
                    )
                  : null,
              onChanged: (value){
                setState(() {

                });
              },
            ),
            SizedBox(height: 24.h),
            HomeContainerWidget(circularImage: AssetImage("assets/circular_avatar/profile.png"), nameText: "Jovidon (Elektrik)", experienceText: "6- yildan beri tajribaga egaman.", onTap: (){
              Navigator.pushNamed(context, RouteNames.workerInfo);
            },),
          ],
        ),
      ),
    );
  }
}
