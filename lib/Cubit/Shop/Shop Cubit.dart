import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobileproject/Screens/Search%20Screen.dart';

import '../../Screens/Cart screen.dart';
import '../../Screens/Home Page.dart';
import '../../Screens/Profile Screen.dart';
import 'Shop States.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    HomePage(),
    SearchScreen(),
    CartPage(),
    ProfileScreen(),
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }
}
