
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CartItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<CartItem> _items = [
    CartItem(
      id: '1',
      name: 'Wireless Earbuds',
      price: 29.99,
      imageUrl: 'https://picsum.photos/200/200?random=1',
    ),
    CartItem(
      id: '2',
      name: 'Smart Watch',
      price: 39.99,
      imageUrl: 'https://picsum.photos/200/200?random=2',
    ),
    CartItem(
      id: '3',
      name: 'Wireless Earbuds',
      price: 29.99,
      imageUrl: 'https://picsum.photos/200/200?random=1',
    ),
    CartItem(
      id: '4',
      name: 'Smart Watch',
      price: 39.99,
      imageUrl: 'https://picsum.photos/200/200?random=2',
    ),
    CartItem(
      id: '5',
      name: 'Wireless Earbuds',
      price: 29.99,
      imageUrl: 'https://picsum.photos/200/200?random=1',
    ),
  ];

  double get total => _items.fold(0, (sum, item) => sum + item.total);

  void _updateQuantity(String id, int change) {
    setState(() {
      final item = _items.firstWhere((item) => item.id == id);
      item.quantity = (item.quantity + change).clamp(1, 99);
    });
  }

  void _removeItem(String id) {
    setState(() => _items.removeWhere((item) => item.id == id));
  }

  Widget _buildCartItem(CartItem item) {
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
                item.imageUrl,
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
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 16),
                              onPressed: () => _updateQuantity(item.id, -1),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 16),
                              onPressed: () => _updateQuantity(item.id, 1),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _removeItem(item.id),
                        color: Colors.red[400],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Proceeding to checkout...')),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Checkout',
              style: TextStyle(
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
        title: const Text('Shopping Cart'),
        elevation: 0,
        centerTitle: true,
      ),
      body: _items.isEmpty
          ? const Center(
        child: Text(
          'Your cart is empty',
          style: TextStyle(fontSize: 18),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              itemBuilder: (context, index) => _buildCartItem(_items[index]),
            ),
          ),
          _buildCheckoutSection(),
        ],
      ),
    );
  }
}