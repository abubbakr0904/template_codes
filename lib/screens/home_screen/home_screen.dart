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
                TextField(
                  controller: textEditingController,
                  style: const TextStyle(
                    fontFamily: AppImages.fontPoppins,
                    color : Colors.white
                  ),
                  onChanged: (v){
                    context.read<RegionBloc>().add(
                      SearchRegionCallEvent(searchTitle: v)
                    );
                    setState(() {

                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.sp,
                        color : Colors.white
                      ),
                    ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1.sp,
                            color : Colors.white
                        ),
                      )
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
                          title: Text(
                            state.currentRegions[index].name,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: AppImages.fontPoppins,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500),
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
