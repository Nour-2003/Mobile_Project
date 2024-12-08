import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileproject/Cubit/Shop/Shop%20Cubit.dart';
import 'package:mobileproject/Cubit/Shop/Shop%20States.dart';
import 'package:mobileproject/Cubit/Theme/Theme%20Cubit.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // Define separate GlobalKeys for each form
  final _formKey1 = GlobalKey<FormState>();  // For Add Product
  final _formKey2 = GlobalKey<FormState>();  // For Add Category

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _countController = TextEditingController();

  String? _selectedCategory;
  List<String> categories = [];
  CollectionReference Products = FirebaseFirestore.instance.collection('Products');

  Future<void> addUser() {
    return Products.add({
      'title': _titleController.text,
      'price': _priceController.text,
      'description': _descriptionController.text,
      'category': _selectedCategory,
      'imageUrl': _imageUrlController.text,
      'rating': _ratingController.text,
      'count': _countController.text,
    }).then((value) => {}).catchError((error) => print("Failed to add user: $error"));
  }

  void getCategories() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Categories').get();
      setState(() {
        categories = querySnapshot.docs.map((doc) => doc['name'] as String).toList();
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
        print(categories);
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: [
                  ExpansionTile(
                    title: Text('Add Product', style: GoogleFonts.montserrat()),
                    children: [
                      Form(
                        key: _formKey1,  // Use _formKey1 here
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title Field
                                TextFormField(
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
                                  controller: _countController,
                                  decoration: const InputDecoration(
                                    labelText: 'Rating (Count)',
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
                                      if (_formKey1.currentState?.validate() ?? false) {
                                        addUser().then((value) {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.success,
                                            animType: AnimType.rightSlide,
                                            title: 'Add Product',
                                            desc: 'Product Added Successfully',
                                          )..show();
                                          ShopCubit.get(context).getData();
                                        });
                                        _titleController.clear();
                                        _priceController.clear();
                                        _descriptionController.clear();
                                        _imageUrlController.clear();
                                        _ratingController.clear();
                                        _countController.clear();
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
                  ExpansionTile(
                    title: Text('Add Category', style: GoogleFonts.montserrat()),
                    children: [
                      Form(
                        key: _formKey2,  // Use _formKey2 here
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title Field
                                TextFormField(
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
                                      if (_formKey2.currentState?.validate() ?? false) {
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
                                          )..show();
                                          getCategories();
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
