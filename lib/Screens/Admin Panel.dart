import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileproject/Cubit/Shop/Shop%20Cubit.dart';
import 'package:mobileproject/Cubit/Shop/Shop%20States.dart';

import '../Cubit/Theme/Theme Cubit.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey1 = GlobalKey<FormState>(); // For Add Product
  final _formKey2 = GlobalKey<FormState>(); // For Add Category

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _countController = TextEditingController();

  String? _selectedCategory;
  List<String> categories = [];
  CollectionReference Products =
      FirebaseFirestore.instance.collection('Products');
  CollectionReference inventoryRef =
      FirebaseFirestore.instance.collection('Inventory');
  Future<void> addUser() async {
    try {
      // Add the product to the main 'Products' collection
      await Products.add({
        'title': _titleController.text,
        'price': _priceController.text,
        'description': _descriptionController.text,
        'category': _selectedCategory,
        'imageUrl': _imageUrlController.text,
        'rating': _ratingController.text,
        'count': _countController.text,
      }).then((value) {
        print("Product added to 'Products' collection.");

        // Clear the input fields after adding the product
        _titleController.clear();
        _priceController.clear();
        _descriptionController.clear();
        _imageUrlController.clear();
        _ratingController.clear();
        _countController.clear();
      }).catchError((error) {
        print("Failed to add product to 'Products' collection: $error");
      });

    } catch (error) {
      print("Error in addUser function: $error");
    }
  }



  void getCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Categories').get();
      setState(() {
        categories =
            querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories(); // Fetch categories when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // Add Product Section
                  ExpansionTile(
                    title: Text(
                      'Add Product',
                      style: GoogleFonts.montserrat(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Form(
                        key: _formKey1, // Use _formKey1 here
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title Field
                                TextFormField(
                                  style: ThemeCubit.get(context).themebool ?  TextStyle(color: Colors.white):TextStyle(color: Colors.black),
                                  controller: _titleController,
                                  decoration: const InputDecoration(
                                    labelText: 'Title',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a title';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Price Field
                                TextFormField(
                                  style: ThemeCubit.get(context).themebool ?  TextStyle(color: Colors.white):TextStyle(color: Colors.black),
                                  controller: _priceController,
                                  decoration: const InputDecoration(
                                    labelText: 'Price',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a price';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Description Field
                                TextFormField(
                                  style: ThemeCubit.get(context).themebool ?  TextStyle(color: Colors.white):TextStyle(color: Colors.black),
                                  controller: _descriptionController,
                                  decoration: const InputDecoration(
                                    labelText: 'Description',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a description';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Category Dropdown
                                DropdownButtonFormField<String>(
                                  dropdownColor: ThemeCubit.get(context).themebool?Colors.grey[800]:Colors.white,
                                    style: ThemeCubit.get(context).themebool ?  TextStyle(color: Colors.white):TextStyle(color: Colors.black),
                                  decoration: const InputDecoration(
                                    labelText: 'Category',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: _selectedCategory,
                                  items: categories
                                      .map((category) => DropdownMenuItem(
                                            value: category,
                                            child: Text(category),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select a category';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Image URL Field
                                TextFormField(
                                  style: ThemeCubit.get(context).themebool ?  TextStyle(color: Colors.white):TextStyle(color: Colors.black),
                                  controller: _imageUrlController,
                                  decoration: const InputDecoration(
                                    labelText: 'Image URL',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an image URL';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Rating Field
                                TextFormField(
                                  style: ThemeCubit.get(context).themebool ?  TextStyle(color: Colors.white):TextStyle(color: Colors.black),
                                  controller: _ratingController,
                                  decoration: const InputDecoration(
                                    labelText: 'Rating (Rate)',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a rating';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Count Field
                                TextFormField(
                                    style: ThemeCubit.get(context).themebool ?  TextStyle(color: Colors.white):TextStyle(color: Colors.black) ,
                                  controller: _countController,
                                  decoration: const InputDecoration(
                                    labelText: 'Product Count',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a count';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),

                                // Submit Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey1.currentState?.validate() ??
                                          false) {
                                        addUser().then((value) {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.success,
                                            animType: AnimType.rightSlide,
                                            title: 'Add Product',
                                            desc: 'Product Added Successfully',
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
                                          ShopCubit.get(context).getData();
                                        });
                                      }
                                    },
                                    child: const Text('Add Product'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Add Category Section

                  SizedBox(
                    height: 10,
                  ),
                  ExpansionTile(
                    title: Text(
                      'Add Category',
                      style: GoogleFonts.montserrat(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Form(
                        key: _formKey2, // Use _formKey2 here
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title Field
                                TextFormField(
                                  style: ThemeCubit.get(context).themebool ?  TextStyle(color: Colors.white):TextStyle(color: Colors.black),
                                  controller: _titleController,
                                  decoration: const InputDecoration(
                                    labelText: 'Title',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a title';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                // ImageUrl Field
                                TextFormField(
                                  style: ThemeCubit.get(context).themebool ?  TextStyle(color: Colors.white):TextStyle(color: Colors.black),
                                  controller: _imageUrlController,
                                  decoration: const InputDecoration(
                                    labelText: 'ImageUrl',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an Image Url';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                // Submit Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey2.currentState?.validate() ??
                                          false) {
                                        FirebaseFirestore.instance
                                            .collection('Categories')
                                            .add({
                                          'name': _titleController.text,
                                          'imageUrl': _imageUrlController.text,
                                        }).then((value) {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.success,
                                            animType: AnimType.rightSlide,
                                            title: 'Add Category',
                                            desc: 'Category Added Successfully',
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
                                          )..show();
                                          getCategories();
                                          ShopCubit.get(context).getCategories();
                                        });
                                        _imageUrlController.clear();
                                        _titleController.clear();
                                      }
                                    },
                                    child: const Text('Add Category'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Get Orders Section
                  SizedBox(
                    height: 10,
                  ),
                  ExpansionTile(
                    title: Text(
                      'All Transactions ',
                      style: GoogleFonts.montserrat(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Orders')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error fetching orders.'));
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text(
                                'No orders found.',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            );
                          }

                          final orders = snapshot.data!.docs;

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              final order = orders[index];
                              final items = order['items'] as List<dynamic>;
                              final status = order['status'];
                              final total = order['total'];
                              final timestamp = order['timestamp'];
                              final rating = order['rating'] ??
                                  0; // Default to 0 if rating is null

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: ExpansionTile(
                                      tilePadding: EdgeInsets.zero,
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Order ID: ${order.id.substring(0, 8)}...',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Chip(
                                            label: Text(
                                              status,
                                              style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            backgroundColor: status == 'pending'
                                                ? Colors.orange
                                                : Colors.green,
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Text(
                                                'Total:',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                '  \$${total.toString()}',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 14,
                                                    color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Date: ${timestamp.toDate()}',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                'Rating:',
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              RatingBarIndicator(
                                                rating: rating.toDouble(),
                                                itemBuilder: (context, _) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                itemCount: 5,
                                                itemSize: 20.0,
                                                direction: Axis.horizontal,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      children: [
                                        const Divider(),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: items.length,
                                          itemBuilder: (context, itemIndex) {
                                            final item = items[itemIndex];
                                            return AnimatedPadding(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                              child: ListTile(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.network(
                                                    item['imageUrl'],
                                                    width: 80,
                                                    // Slightly increased for better visibility
                                                    height: 80,
                                                    fit: BoxFit.fitHeight,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Container(
                                                      width: 80,
                                                      height: 80,
                                                      color: Colors.grey,
                                                      // Placeholder color when image fails to load
                                                      child: const Icon(
                                                          Icons.error,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  item['title'],
                                                  maxLines: 2,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,

                                                  ),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Quantity: ${item['quantity']}',
                                                      style:  GoogleFonts.montserrat(
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                      maxLines: 1,
                                                      // Limit subtitle to 1 line
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      'Price: \$${item['price']}',
                                                      style:GoogleFonts.montserrat(
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                      maxLines: 1,
                                                      // Limit subtitle to 1 line
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      'Subtotal: \$${(double.parse(item['price']) * item['quantity']).toStringAsFixed(2)}',
                                                      style: GoogleFonts.montserrat(
                                                        fontSize: 12,
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ExpansionTile(
                    title: Text(
                      'Best Selling Products',
                      style: GoogleFonts.montserrat(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: inventoryRef.snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Error fetching inventory data.'));
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text(
                                'No inventory data found.',
                                style: GoogleFonts.montserrat(fontSize: 16, color: Colors.grey),
                              ),
                            );
                          }

                          final inventoryItems = snapshot.data!.docs;

                          // Map to store the quantity of each product
                          Map<String, double> quantityMap = {};

                          for (var doc in inventoryItems) {
                            var data = doc.data() as Map<String, dynamic>;
                            var productName = data['name'];
                            var quantity = double.tryParse(data['quantity'].toString()) ?? 0.0;

                            if (quantity > 0) {
                              quantityMap[productName] = quantity;
                            }
                          }

                          // Convert to sorted list
                          List<MapEntry<String, double>> sortedList = quantityMap.entries.toList()
                            ..sort((a, b) => b.value.compareTo(a.value));

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3, // Adjusted flex to fit better
                                  child: AspectRatio(
                                    aspectRatio: 0.8, // Smaller aspect ratio for a smaller chart
                                    child: PieChart(
                                      PieChartData(
                                        sectionsSpace: 3,
                                        borderData: FlBorderData(show: false),
                                        sections: sortedList.take(5).map((entry) {
                                          double percentage = (entry.value / quantityMap.values.fold(0.0, (sum, quantity) => sum + quantity)) * 100;
                                          return PieChartSectionData(
                                            value: entry.value,
                                            title: '${percentage.toStringAsFixed(1)}%',
                                            color: Colors.primaries[sortedList.indexOf(entry) % Colors.primaries.length],
                                            radius: 50,
                                            titleStyle: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: sortedList.take(5).map((entry) {
                                      return Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            color: Colors.primaries[sortedList.indexOf(entry) % Colors.primaries.length],
                                          ),
                                          SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              '${entry.key} (${(entry.value / quantityMap.values.fold(0.0, (sum, quantity) => sum + quantity) * 100).toStringAsFixed(1)}%)',
                                              style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  )

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
