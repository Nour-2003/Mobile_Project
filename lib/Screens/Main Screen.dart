
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobileproject/Cubit/Shop/Shop%20States.dart';

import '../Cubit/Shop/Shop Cubit.dart';

class MainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopCubit(),
      child: BlocConsumer<ShopCubit,ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ShopCubit.get(context);
          return  Scaffold(
              body: cubit.screens[cubit.currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),

                  BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
                  BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
                ],
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeBottomNav(index);
                },
              ),
            );
        },
      ),
    );
  }
}

