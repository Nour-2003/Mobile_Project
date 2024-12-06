import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
    firebaseProducts.clear();
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
  List CartItems =[];
  void getCartData() async{
    emit(GetCartData());
    CollectionReference Cart = FirebaseFirestore.instance.collection('Cart');
    Cart.where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get().then((querySnapshot) {
      CartItems.addAll(querySnapshot.docs);
      emit(GetCartDataSuccess());
    }).catchError((error) {
      emit(GetCartDataError());
    });
  }
  void addToCart(String title,String price,String description,String category,String imageUrl,String rating,String count) async{
    CollectionReference Cart = FirebaseFirestore.instance.collection('Cart');
        Cart
          .add({
        'title':title,
        'price': price, // Stokes and Sons
        'description': description, // 42
        'category': category, // 42
        'imageUrl': imageUrl, // 42
        'rating': rating, // 42
        'count': count, // 42
          "id":FirebaseAuth.instance.currentUser!.uid
      })
          .then((value) => {
        print("Cart item Added"),
        emit(AddToCartSuccess())
      })
          .catchError((error) => print("Failed to add item: $error"));
  }

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
  List categoryProducts = [];
List firebaseCategories = [];
  void getCategories() async {
    emit(ShopGetCategories());
    try {
      QuerySnapshot query = await FirebaseFirestore.instance.collection('Categories').get();
      firebaseCategories = query.docs;
      emit(ShopGetCategoriesSuccess());
    } catch (error) {
      emit(ShopGetCategoriesError());
    }
  }
  void getProductsFromCategory(String categoryName) async {
    emit(ShopLoadingCatProductsDataState());
    try {
      categoryProducts.clear();
      QuerySnapshot query = await FirebaseFirestore.instance.collection('${categoryName}').get();
      categoryProducts = query.docs;
      emit(ShopSuccessCatProductsDataState());
    } catch (error) {
      print('Error getting products for category $categoryName: $error');
      emit(ShopErrorCatProductsDataState());
    }
  }

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
