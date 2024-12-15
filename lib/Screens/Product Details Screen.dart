import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileproject/Cubit/Shop/Shop%20Cubit.dart';
import 'package:mobileproject/Cubit/Shop/Shop%20States.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mobileproject/Shared/Constants.dart';

import '../Cubit/Theme/Theme Cubit.dart';

class ProductDetails extends StatefulWidget {
  final String productId;
  late  String title;
  final String imageUrl;
  late  String description;
  late  String price;
  final String rating;
  final String reviews;
  final String category;
  final String role;

  ProductDetails({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.category,
    required this.role,
    Key? key,
  }) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ShopCubit>(context); // Access ShopCubit instance

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(35),
                // child: Image.network(
                //   widget.imageUrl,
                //   height: 250,
                //   width: double.infinity,
                //   fit: BoxFit.contain,
                // ),
                child:(widget.imageUrl.isNotEmpty)
                    ? FadeInImage.assetNetwork(
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    placeholder: "Images/Animation - 1734121167586.gif",
                    image:widget.imageUrl)
                    : Image.asset("Images/placeholder.png"),
              ),
              const SizedBox(height: 20),
              Text(
                widget.title,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '\$${widget.price}',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    '${widget.rating} (${widget.reviews} reviews)',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Description',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isExpanded
                          ? widget.description
                          : '${widget.description.substring(0, widget.description.length > 100 ? 100 : widget.description.length)}...', // Truncate
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        height: 1.5,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded; // Toggle state
                        });
                      },
                      child: Text(
                        _isExpanded ? 'See Less' : 'See More',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              widget.role == 'admin'
                  ? ElevatedButton.icon(
                    onPressed: () => _showEditDialog(context),
                    icon: const Icon(Icons.edit),
                    label: Text(
                      'Edit Product',
                      style: GoogleFonts.montserrat(fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 13,
                      ),
                      backgroundColor: defaultcolor,
                    ),
                  )
                  : ElevatedButton.icon(
                    onPressed: () {
                      cubit.addToCart(
                        widget.title,
                        widget.price,
                        widget.description,
                        widget.category,
                        widget.imageUrl,
                        widget.rating,
                        widget.reviews,
                      ).then((value) {
                        if (context.mounted) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.bottomSlide,
                            title: 'Success',
                            desc: 'Product added to cart successfully',
                            btnOkOnPress: () {},
                            titleTextStyle: GoogleFonts
                                .montserrat(
                              fontSize: 20,
                              fontWeight:
                              FontWeight
                                  .bold,
                              color: ThemeCubit.get(context).themebool ? Colors.white:Colors.black,
                            ),
                            descTextStyle:GoogleFonts
                                .montserrat(
                              fontSize: 17,
                              fontWeight:
                              FontWeight
                                  .bold,
                              color: ThemeCubit.get(context).themebool ? Colors.white:Colors.black,
                            ) ,
                            dialogBackgroundColor: ThemeCubit.get(context).themebool ? Colors.grey[800]:Colors.white,
                          ).show();
                        }
                      });
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: Text(
                      'Add to Cart',
                      style: GoogleFonts.montserrat(fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final TextEditingController titleController =
    TextEditingController(text: widget.title);
    final TextEditingController priceController =
    TextEditingController(text: widget.price);
    final TextEditingController descriptionController =
    TextEditingController(text: widget.description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeCubit.get(context).themebool ? Colors.grey[800]:Colors.white,
          title: Text('Edit Product',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,color: ThemeCubit.get(context).themebool ? Colors.white:Colors.black)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  style: ThemeCubit.get(context).themebool ?  TextStyle(color: Colors.white):TextStyle(color: Colors.black),
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                SizedBox(height: 10),
                TextField(
                  style: ThemeCubit.get(context).themebool ?  TextStyle(color: Colors.white):TextStyle(color: Colors.black),
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  style: ThemeCubit.get(context).themebool ?  TextStyle(color: Colors.white):TextStyle(color: Colors.black),
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                if (context.mounted) {
                  final cubit = BlocProvider.of<ShopCubit>(context);
                  cubit.updateProduct(
                    widget.productId,
                    titleController.text,
                    priceController.text,
                    descriptionController.text,
                  ).then((value) {
                    if (context.mounted) {
                      cubit.getData();
                      Navigator.of(context).pop(); // Close dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Product updated successfully'),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 3),
                        ),
                      );

                      setState(() {
                        widget.title = titleController.text;
                        widget.price = priceController.text;
                        widget.description = descriptionController.text;
                      });
                    }
                  }).catchError((error) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update product: $error'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  });
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
