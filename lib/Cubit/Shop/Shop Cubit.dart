import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobileproject/Screens/Add%20Product%20Screen.dart';
import 'package:mobileproject/Screens/Search%20Screen.dart';
import '../../Models/Product Model.dart';
import '../../Screens/Cart screen.dart';
import '../../Screens/Home Page.dart';
import '../../Screens/Profile Screen.dart';
import '../../Services/Dio Package.dart';
import 'Shop States.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);
  List firebaseProducts = [];
  void getData() async{
    QuerySnapshot query = await FirebaseFirestore.instance.collection('Products').get();
    firebaseProducts.addAll(query.docs);
    emit(GetFirebaseDataState());
  }
  Map<String, dynamic>? userData;

  // Method to get user by email
  void getUserByEmail(String email) {
    emit(UserLoading()); // Emit loading state
    try {

      CollectionReference users = FirebaseFirestore.instance.collection('Users');


      users.where('email', isEqualTo: email).get().then((querySnapshot) {

        if (querySnapshot.docs.isNotEmpty) {

          userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
          emit(UserLoaded(userData!));
        } else {
          emit(UserError('No user found with email: $email'));
        }
      }).catchError((e) {
        emit(UserError('Error fetching user by email: $e'));
      });
    } catch (e) {
      emit(UserError('Unexpected error occurred: $e')); // Emit error state
    }
  }
  int currentIndex = 0;
  List<Widget> screens = [
    HomePage(),
    SearchScreen(),
    CartPage(),
    AddProductScreen(),
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
  List products =[];
  List filteredProducts = [];
  void loadProducts(List newProducts) {
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
      product['title'].toLowerCase().contains(searchTerm.toLowerCase()) ||
          product['category'].toLowerCase().contains(searchTerm.toLowerCase()))
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
