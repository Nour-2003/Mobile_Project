import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileproject/Screens/Barcode%20Screen.dart';
import 'package:mobileproject/Screens/Product%20Details%20Screen.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../Cubit/Shop/Shop Cubit.dart';
import '../Cubit/Shop/Shop States.dart';
import '../Cubit/Theme/Theme Cubit.dart';
import '../Shared/Constants.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final textController = TextEditingController();
  final SpeechToText speech = SpeechToText();
  bool speechEnabled = false;
  String lastWords = "";

  @override
  void initState() {
    super.initState();
    initSpeech();
    BlocProvider.of<ShopCubit>(context).loadProducts(ShopCubit.get(context).firebaseProducts);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<ShopCubit>(context).searchProducts('');
    });
  }

  void initSpeech() async {
    speechEnabled = await speech.initialize();
    setState(() {});
  }
//   String barcodeString = "";
//   Future<void> scanBarCodeNormal() async{
//     String ?barcode;
//     try {
//       barcode = await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true, ScanMode.BARCODE);
//       print(barcode);
//     } catch (e) {
//       print(e);
//     }
//     if(!mounted)
//       {
//         return;
//       }
//     setState(() {
// barcodeString = barcode!;
//     });
//   }
  void startListening(ShopCubit cubit) async {
    if (speechEnabled) {
      await speech.listen(onResult: onSpeechResult);
      setState(() {});
    }
  }

  void stopListening() async {
    await speech.stop();
    setState(() {
      lastWords = '';
    });
  }

  void onSpeechResult(result) {
    setState(() {
      lastWords = result.recognizedWords.trim(); // Get recognized speech
      textController.text = lastWords; // Update the text field with the speech result
      // Trigger search with the speech input
      BlocProvider.of<ShopCubit>(context).searchProducts(lastWords);
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopCubit, ShopStates>(
      builder: (context, state) {
        var cubit = ShopCubit.get(context);

        return Scaffold(
          // appBar: AppBar(
          //   centerTitle: true,
          //   title: Text('Search Page'),
          // ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: defaultTextFormField(
                          isDark: ThemeCubit.get(context).themebool,
                          textController: textController,
                          label: 'Search',
                          type: TextInputType.text,
                          prefixIcon: Icon(CupertinoIcons.search),
                          Validator: (value) {
                            if (value!.isEmpty) {
                              return 'Search must not be empty';
                            }
                            return null;
                          },
                          onSubmit: (value) {
                            cubit.searchProducts(value);
                          },
                          onChange: (value) {
                            cubit.searchProducts(value);
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: defaultcolor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            speech.isListening
                                ? Icons.mic
                                : Icons.mic_off_sharp,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (speechEnabled) {
                              if (speech.isListening) {
                                stopListening();
                              } else {
                                startListening(cubit);
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: defaultcolor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.qr_code_scanner_sharp,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BarcodeScreen(role: cubit.userData?['role'],)));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  state is ShopSearchState || state is ShopProductsLoadedState
                      ? cubit.filteredProducts.isEmpty
                      ? Center(
                    child: Text(
                      'No Products Found',
                      style: GoogleFonts.montserrat(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: GridView.count(
                      shrinkWrap: true,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.58,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      children: List.generate(
                          cubit.filteredProducts.length, (index) {
                        var product = cubit.filteredProducts[index];
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(context, PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => ProductDetails(
                                  role: cubit.userData?['role'],
                                  productId: product.id,
                                  title: product['title'],
                                  imageUrl: product['imageUrl'],
                                  price: product['price'],
                                  description: product['description'],
                                  rating: product['rating'],
                                  category: product['category'],
                                  reviews: product['count'],
                                ),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  const begin = Offset(0.0, 1.0); // Start from bottom
                                  const end = Offset.zero; // End at the top
                                  const curve = Curves.easeInOut; // Smooth curve

                                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                  var offsetAnimation = animation.drive(tween);

                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                              )).then((_) {
                                initSpeech();
                                BlocProvider.of<ShopCubit>(context).loadProducts(ShopCubit.get(context).firebaseProducts);
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  BlocProvider.of<ShopCubit>(context).searchProducts('');
                                });
                              });
                            },
                            child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  child: Image(
                                    image: NetworkImage(product['imageUrl']),
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${product['title']}",
                                        maxLines: 2,
                                        style: GoogleFonts.montserrat(
                                            fontSize: 14, fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "${product['category']}",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "\$${product['price']}",
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: Row(
                                          children: [
                                            Row(
                                              children: List.generate(
                                                5, // Assuming a 5-star rating system
                                                    (starIndex) => Icon(
                                                  starIndex < double.parse(product['rating'])
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: Colors.amber,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "${product['rating']}", // Display numerical rating
                                              style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  )
                      : CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
