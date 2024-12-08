import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileproject/Cubit/Shop/Shop%20Cubit.dart';
import 'package:mobileproject/Cubit/Shop/Shop%20States.dart';

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
    }).then((value) => {}).catchError((error) => print("Failed to add product: $error"));
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
                    title: Text('Add Product', style: GoogleFonts.montserrat()),
                    children: [
                      Form(
                        key: _formKey1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _titleController,
                                decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a title';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              // Other fields...
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Add Category Section
                  ExpansionTile(
                    title: Text('Add Category', style: GoogleFonts.montserrat()),
                    children: [
                      Form(
                        key: _formKey2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _titleController,
                                decoration: const InputDecoration(labelText: 'Category Name', border: OutlineInputBorder()),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a category name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Get Orders Section
                  ExpansionTile(
                    title: Text(
                      'Get Orders',
                      style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('Orders').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Error fetching orders.'));
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text(
                                'No orders found.',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            );
                          }

                          final orders = snapshot.data!.docs;

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              final order = orders[index];
                              final items = order['items'] as List<dynamic>;
                              final status = order['status'];
                              final total = order['total'];
                              final timestamp = order['timestamp'];

                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: ExpansionTile(
                                    tilePadding: EdgeInsets.zero,
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Order ID: ${order.id.substring(0, 8)}...',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Chip(
                                          label: Text(
                                            status,
                                            style: TextStyle(
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          'Total: \$${total.toString()}',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Date: ${timestamp.toDate()}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    children: [
                                      Divider(),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: items.length,
                                        itemBuilder: (context, itemIndex) {
                                          final item = items[itemIndex];
                                          return ListTile(
                                            contentPadding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 8),
                                            leading: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.network(
                                                item['imageUrl'],
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            title: Text(
                                              item['title'],
                                              style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            subtitle: Text(
                                              'Quantity: ${item['quantity']} | Price: \$${item['price']}',
                                              style: TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                            trailing: Text(
                                              'Subtotal: \$${(double.parse(item['price']) * item['quantity']).toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
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
