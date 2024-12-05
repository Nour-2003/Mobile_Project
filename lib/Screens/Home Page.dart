import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileproject/Cubit/Shop/Shop%20Cubit.dart';
import 'package:mobileproject/Cubit/Shop/Shop%20States.dart';
import 'package:mobileproject/Models/Product%20Model.dart';
import 'package:mobileproject/Screens/Category%20Screen.dart';
import 'package:mobileproject/Screens/Product%20Details%20Screen.dart';

import '../Shared/Constants.dart';

class HomePage extends StatelessWidget {
  final List<String> images = [
    'Images/devices-svgrepo-com.png',
    'Images/jewelry-store-luxury-goods-expensive-item-svgrepo-com.png',
    'Images/men-jacket-svgrepo-com.png',
    'Images/women-suit-svgrepo-com.png',
  ];
  final List<String> names = [
    "electronics",
    "jewelery",
    "men's clothing",
    "women's clothing"
  ];
 List Data = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          List<Product> products = ShopCubit.get(context).productModel.products;
          print(products.length);
          Data = ShopCubit.get(context).firebaseProducts;
          print("Fire Base Data Here "+ Data.length.toString());
          return Scaffold(
            appBar: AppBar(
              title: Text('Home Page'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text('Categories',
                        style: GoogleFonts.montserrat(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    Container(
                      height: 100,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryScreen(
                                  categoryName: names[index],
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              ClipRRect(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Image.asset(
                                    images[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.black.withOpacity(0.8),
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    names[index],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemCount: images.length,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text('Top Products:',
                        style: GoogleFonts.montserrat(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    ConditionalBuilder(
                      condition: Data.isNotEmpty,
                      fallback: (context) => Center(
                        child: Center(
                            child: CircularProgressIndicator(
                          color: defaultcolor,
                        )),
                      ),
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: GridView.count(
                            shrinkWrap: true,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.57,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            children: List.generate(Data.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetails(
                                            title: Data[index]['title'],
                                            imageUrl: Data[index]['imageUrl'],
                                            description:
                                            Data[index]['description'],
                                            price: Data[index]['price'],
                                            rating: Data[index]['rating'],
                                            reviews:
                                            Data[index]['count'])),
                                  );
                                },
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        content: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          // Set a fixed width
                                          constraints: const BoxConstraints(
                                            maxHeight:
                                                400, // Ensure the dialog has a maximum height
                                          ),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    Data[index]['imageUrl'],
                                                    height: 250,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  "Category: ${Data[index]['category']}",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 14,
                                                      color: Colors.grey[700]),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  "Price: \$${Data[index]['price']}",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  "Rating: ${Data[index]['rating']} (${Data[index]['count']} reviews)",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 14,
                                                      color: Colors.amber),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  Data[index]['description'],
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 14,
                                                      color: Colors.grey[800]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Close",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                        child: Image(
                                          image: NetworkImage(
                                              Data[index]['imageUrl']),
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${Data[index]['title']}",
                                              maxLines: 2,
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "${Data[index]['category']}",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "\$${Data[index]['price']}",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.blue),
                                                  ),
                                                  Material(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: InkWell(
                                                      onTap: () {},
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: Icon(
                                                          Icons.favorite_border,
                                                          color:
                                                              Colors.grey[600],
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              child: Row(
                                                children: [
                                                  Row(
                                                    children: List.generate(
                                                      5,
                                                      // Assuming a 5-star rating system
                                                      (starIndex) => Icon(
                                                        starIndex <
                                                            double.parse(Data[index]['rating'])
                                                            ? Icons.star
                                                            : Icons.star_border,
                                                        color: Colors.amber,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    "${Data[index]['rating']}",
                                                    // Display numerical rating
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

int calculateDiscountPercentage(dynamic oldPrice, dynamic newPrice) {
  // Convert to double to ensure correct calculation
  double oldPriceDouble = oldPrice.toDouble();
  double newPriceDouble = newPrice.toDouble();

  return ((oldPriceDouble - newPriceDouble) / oldPriceDouble * 100).round();
}
