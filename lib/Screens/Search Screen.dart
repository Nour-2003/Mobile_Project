
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileproject/Shared/Constants.dart';

class SearchScreen extends StatelessWidget {
  var textController = TextEditingController();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              defaultTextFormField(textController: textController,
                  label:  'Search',
                  type: TextInputType.text,
                  prefixIcon: Icon(CupertinoIcons.search),
                  Validator: (value)
              {
                if(value!.isEmpty)
                {
                  return 'Search must not be empty';
                }
                return null;
              }),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: GridView.count(
                  shrinkWrap: true,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.7,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  children: List.generate(10, (index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                            child: const Image(
                              image: NetworkImage(
                                  "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg"),
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "IPhone 8 Pro",
                                  maxLines: 2,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Category: Electronics",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "\$1200",
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
