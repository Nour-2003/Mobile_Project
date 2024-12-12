import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileproject/Cubit/Theme/Theme%20Cubit.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ShowOrderPage extends StatelessWidget {
  final List<Map<String, dynamic>> orderItems;
  final double orderTotal;
  double? finalRating;

  ShowOrderPage({
    Key? key,
    required this.orderItems,
    required this.orderTotal,
  }) : super(key: key);

  Widget _buildOrderItem(Map<String, dynamic> item) {
    final double price = (double.parse(item['price']) ?? 0);
    final int quantity = (item['quantity'] ?? 1).toInt();
    final double total = price * quantity;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item['imageUrl'] ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: GoogleFonts.montserrat(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Quantity: $quantity',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Subtotal: \$${total.toStringAsFixed(2)}',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitOrder(BuildContext context) async {
    try {
      final orderRef = FirebaseFirestore.instance.collection('Orders');
      final newOrder = await orderRef.add({
        'items': orderItems,
        'total': orderTotal.toStringAsFixed(2),
        'status': 'pending',
        'rating': 0,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Add the generated order ID to each item for reference
      for (var item in orderItems) {
        item['orderId'] = newOrder.id;
      }
      print("Order added with ID: ${newOrder.id}");

      final inventoryRef = FirebaseFirestore.instance.collection('Inventory');

      for (var item in orderItems) {
        final itemName = item['title'];
        final orderQuantity = item['quantity'];
        print("Processing item: $itemName, Quantity: $orderQuantity");

        // Search for the item in the inventory
        final querySnapshot = await inventoryRef.where('name', isEqualTo: itemName).get();
        if (querySnapshot.docs.isNotEmpty) {
          print("Item exists in inventory. Updating quantity.");
          // Item exists, update its quantity
          final docRef = querySnapshot.docs.first.reference;
          await docRef.update({
            'quantity': FieldValue.increment(orderQuantity),
          });
          print("Updated inventory for $itemName with quantity -$orderQuantity");
        } else {
          print("Item does not exist in inventory. Adding new item.");
          // Item does not exist, add a new document
          await inventoryRef.add({
            'name': itemName,
            'quantity': orderQuantity, // Start with the negative quantity for the order
          });
          print("Added new inventory item: $itemName with quantity -$orderQuantity");
        }
      }

      // Manage Cart updates
      final cartRef = FirebaseFirestore.instance.collection('Cart');
      final batch = FirebaseFirestore.instance.batch();

      for (var item in orderItems) {
        if (item['id'] != null) {
          final docRef = cartRef.doc(item['id']);
          batch.delete(docRef);
        }
      }

      await batch.commit();
      print("Cart updates committed.");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order submitted successfully!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting order: ${e.toString()}')),
        );
      }
    }
  }



  Future<void> _submitRating(BuildContext context) async {
    double? userRating;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rate Your Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How would you rate your order experience?'),
              const SizedBox(height: 16),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  userRating = rating;
                  finalRating = rating;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (userRating != null) {
                  try {
                    // Ensure the order has a unique ID, provided in the order data
                    final String orderId = orderItems.isNotEmpty ? orderItems[0]['orderId'] ?? '' : '';

                    if (orderId.isNotEmpty) {
                      final orderRef = FirebaseFirestore.instance.collection('Orders').doc(orderId);

                      // Update the rating field for the specific order
                      await orderRef.update({'rating': userRating});

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rating submitted successfully!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order ID not found!')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error submitting rating: ${e.toString()}')),
                    );
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubmitSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: ThemeCubit.get(context).themebool ? Colors.grey[800] : Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${orderTotal.toStringAsFixed(2)}',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _submitOrder(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Submit Order',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _submitRating(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Rate Order',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        elevation: 0,
        centerTitle: true,
      ),
      body: orderItems.isEmpty
          ? const Center(
        child: Text(
          'No items in your order',
          style: TextStyle(fontSize: 18),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orderItems.length,
              itemBuilder: (context, index) =>
                  _buildOrderItem(orderItems[index]),
            ),
          ),
          _buildSubmitSection(context),
        ],
      ),
    );
  }
}
