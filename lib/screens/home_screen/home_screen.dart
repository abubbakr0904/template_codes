import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_codes/bloc/region/region_event.dart';
import 'package:template_codes/data/model/forms_status/forms_satatus.dart';
import 'package:template_codes/utils/app_images/app_images.dart';
import '../../bloc/region/region_bloc.dart';
import '../../bloc/region/region_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Place names",
          style: TextStyle(
            color: Colors.white,
            fontFamily: AppImages.fontPoppins,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<RegionBloc, RegionState>(
        builder: (context, state) {
          if (state.formsStatus == FormsStatus.error) {
            return Center(
                child: Text(
              "We have error",
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 35.sp,
                  fontFamily: AppImages.fontPoppins),
            ));
          }
          if (state.formsStatus == FormsStatus.success) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: textEditingController,
                    style: const TextStyle(
                        fontFamily: AppImages.fontPoppins, color: Colors.white),
                    onChanged: (v) {
                      context
                          .read<RegionBloc>()
                          .add(SearchRegionCallEvent(searchTitle: v));
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: const TextStyle(
                            fontFamily: AppImages.fontPoppins,
                            color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1.sp, color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1.sp, color: Colors.white),
                        )),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ...List.generate(
                        state.currentRegions.length,
                        (index) => ListTile(
                          leading: Image.asset(AppImages.location,
                              width: 40.w, height: 40.w, fit: BoxFit.cover),
                          title: RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                    text: state.currentRegions[index].name.substring(0 , textEditingController.text.length),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: AppImages.fontPoppins,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w800)),
                                TextSpan(
                                    text: state.currentRegions[index].name
                                        .substring(
                                            textEditingController.text.length,
                                            state.currentRegions[index].name
                                                .length),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: AppImages.fontPoppins,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
// 15611
