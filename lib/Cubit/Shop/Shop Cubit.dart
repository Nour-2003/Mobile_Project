import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobileproject/Screens/Search%20Screen.dart';

import '../../Dio/Dio Package.dart';
import '../../Models/Product Model.dart';
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
  ProductModel productModel = ProductModel(
      products : [],
  );

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(url: 'products').then((value) {
      productModel = ProductModel.fromJson(value.data);
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }
  List<Product> products =[];
  List<Product> filteredProducts = [];
  void loadProducts(List<Product> newProducts) {
    products = newProducts;
    filteredProducts = List.from(products); // Initially show all products
    emit(ShopProductsLoadedState());
  }

  void searchProducts(String searchTerm) {
    emit(ShopSearchLoadingState());

    if (searchTerm.isEmpty) {
      filteredProducts = List.from(products);
    } else {
      filteredProducts = products
          .where((product) =>
      product.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
          product.category.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }

    emit(ShopSearchState());
  }

  ProductModel categoryProductModel = ProductModel(
    products: [],
  );

  void getCatProductsData(String name) {
    emit(ShopLoadingCatProductsDataState());
    DioHelper.getData(url: 'products/category/$name').then((value) {
      categoryProductModel = ProductModel.fromJson(value.data);
      emit(ShopSuccessCatProductsDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCatProductsDataState());
    });
  }
}
