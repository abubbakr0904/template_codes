import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_codes/screens/home_screen/home_screen.dart';

import 'bloc/region/region_bloc.dart';
import 'bloc/region/region_event.dart';
import 'data/local/places_data.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  PlacesDatabase.instance;

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => PlacesDatabase()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => RegionBloc(
              context.read<PlacesDatabase>(),
            )..add(RegionCallEvent()),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) {
            ScreenUtil.init(context);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: child,
            );
          },
          child: const HomeScreen(),
        ),
      ),
    );
  }
}
