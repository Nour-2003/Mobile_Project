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
  void getData() async {
    emit(GetFirebaseDataLoadingState()); // Optional: For showing a loading spinner
    try {
      firebaseProducts.clear();
      QuerySnapshot query = await FirebaseFirestore.instance.collection('Products').get();
      firebaseProducts.addAll(query.docs);
      emit(GetFirebaseDataState());
    } catch (error) {
      emit(GetFirebaseDataErrorState(error.toString()));
    }
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
  List<String> titles = [
    'Home',
    'Search',
    'Cart',
    'Admin Panel',
    'Profile',
  ];
  List<String> adminTitles = [
    'Home',
    'Search',
    'Admin Panel',
    'Profile'
  ];
  List<Widget> screens = [
    HomePage(),
    SearchScreen(),
    CartPage(),
    ProfileScreen(),
  ];
  List<Widget> adminScreens = [
    HomePage(),
    SearchScreen(),
    AddProductScreen(),
    ProfileScreen(),
  ];
  List CartItems =[];
  void getCartData() {
    emit(GetCartData());
    FirebaseFirestore.instance
        .collection('Cart')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      CartItems = snapshot.docs;
      emit(GetCartDataSuccess());
    }, onError: (error) {
      print("Error getting cart data: $error");
      emit(GetCartDataError());
    });
  }

  Future<void> addToCart(
      String title, String price, String description, String category, String imageUrl, String rating, String count) async {
    try {
      // Get the current user's ID
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // Query the Cart collection for the product with the same title and user ID
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Cart')
          .where('title', isEqualTo: title)
          .where('id', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Product already exists in the cart, update the quantity
        final docId = querySnapshot.docs.first.id; // Get the document ID
        final currentQuantity = querySnapshot.docs.first.data()['quantity'] as int;

        await FirebaseFirestore.instance.collection('Cart').doc(docId).update({
          'quantity': currentQuantity + 1,
        });

        emit(AddToCartSuccess());
      } else {
        // Product not found, add a new entry
        await FirebaseFirestore.instance.collection('Cart').add({
          'title': title,
          'price': price,
          'description': description,
          'category': category,
          'imageUrl': imageUrl,
          'rating': rating,
          'count': count,
          'id': userId,
          'quantity': 1,
        });

        emit(AddToCartSuccess());
      }
    } catch (error) {
      print("Failed to add/update item: $error");
      emit(AddToCartError());
    }
  }


  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }
  ProductModel productModel = ProductModel(
      products : [],
  );


  List products =[];
  List filteredProducts = [];
  void loadProducts(List newProducts) {
    products = newProducts;
    filteredProducts = List.from(products);
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
  String selectedCategory = '';
  void selectCategory(String categoryName) {
    if (selectedCategory != categoryName) {
      selectedCategory = categoryName;
      getProductsFromCategory(categoryName);
    }
  }
  void getProductsFromCategory(String categoryName) async {
    emit(ShopLoadingCatProductsDataState());
    try {
      categoryProducts.clear();
      QuerySnapshot query = await FirebaseFirestore.instance.collection('${categoryName}').get();
      categoryProducts = query.docs;
      print(categoryProducts.length);
      emit(ShopSuccessCatProductsDataState());
    } catch (error) {
      print('Error getting products for category $categoryName: $error');
      emit(ShopErrorCatProductsDataState());
    }
  }


  Future<void> updateProduct(String productId, String title, String price, String description) async {
    try {
      // Update the main 'Products' collection
      await FirebaseFirestore.instance.collection('Products').doc(productId).update({
        'title': title,
        'price': price,
        'description': description,
      });

      // Update local Data list
      int index = firebaseProducts.indexWhere((product) => product['id'] == productId);
      if (index != -1) {
        firebaseProducts[index]['title'] = title;
        firebaseProducts[index]['price'] = price;
        firebaseProducts[index]['description'] = description;
        emit(ProductsUpdatedState()); // Trigger UI rebuild
      }

      // Update corresponding product in the category collection
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance.collection('Products').doc(productId).get();
      if (productSnapshot.exists) {
        String category = productSnapshot['category'];

        // Get the collection reference for the specific category
        CollectionReference categoryCollection = FirebaseFirestore.instance.collection(category);

        // Search for the product in the category collection by title and update it
        await categoryCollection.where('title', isEqualTo: title).limit(1).get().then((querySnapshot) async {
          if (querySnapshot.docs.isNotEmpty) {
            DocumentReference docRef = querySnapshot.docs.first.reference;
            await docRef.update({
              'title': title,
              'price': price,
              'description': description,
            });
          }
        }).catchError((error) {
          print("Failed to update product in category: $error");
        });
      }

      emit(ProductUpdatedSuccessState());
    } catch (error) {
      emit(ProductUpdatedErrorState(error.toString()));
    }
  }



}
