import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobileproject/Screens/Login%20Screen.dart';

import 'Cubit/Shop/Shop Cubit.dart';
import 'Cubit/Theme/Theme Cubit.dart';
import 'Cubit/Theme/Theme States.dart';
import 'Dio/Dio Package.dart';
import 'Screens/OnBoarding Screen.dart';
import 'Shared/Constants.dart';
import 'Shared/Themes.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ShopCubit>(
          create: (context) => ShopCubit(),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocConsumer<ThemeCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeCubit.get(context).themebool ? ThemeMode.dark : ThemeMode.light,
            home: Directionality(
              textDirection: TextDirection.ltr,
              child: OnBoardingScreen(),
            ),
          );
        },
      ),
    );
  }
}
