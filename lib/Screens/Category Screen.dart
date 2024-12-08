import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileproject/Cubit/Shop/Shop%20Cubit.dart';
import 'package:mobileproject/Cubit/Shop/Shop%20States.dart';
import 'package:mobileproject/Screens/Product%20Details%20Screen.dart';
import 'package:mobileproject/Shared/Constants.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;
  CategoryScreen({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopCubit()..getProductsFromCategory(categoryName),
      child: BlocBuilder<ShopCubit, ShopStates>(
        builder: (context, state) {
          var cubit = ShopCubit.get(context);
          print(cubit.categoryProducts.length);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(categoryName),
            ),
            body: state is ShopLoadingCatProductsDataState
                ? Center(child: CircularProgressIndicator(
              color: defaultcolor,
            ))
                : cubit.categoryProducts.isEmpty
                ? Center(
              child: Text(
                'No products found in $categoryName',
                style: TextStyle(fontSize: 18),
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(15.0),
              child: GridView.builder(
                itemCount: cubit.categoryProducts.length,
                shrinkWrap: true,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio:  0.57,
                ),
                itemBuilder: (context, index) {
                  var product = cubit.categoryProducts[index];
                  return GestureDetector(
                    onTap: () {
                   Navigator.push(context,
                   MaterialPageRoute(builder:(context) => ProductDetails(
                      title: product['title'],
                      imageUrl: product['imageUrl'],
                      description: product['description'],
                      price: product['price'],
                      rating: product['rating'],
                      reviews: product['count'],
                      category: product['category'],
                   ) )
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
                                      Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                        child: InkWell(
                                          onTap: () {},
                                          borderRadius: BorderRadius.circular(20),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.favorite_border,
                                              color: Colors.grey[600],
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
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
