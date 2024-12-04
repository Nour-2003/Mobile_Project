import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetails extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  final double rating;
  final int reviews;

  const ProductDetails({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviews,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Theme-based colors
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;
    final cardColor = theme.cardColor;

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
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 20),
              // Title
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Price
              Text(
                '\$$price',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              // Ratings and Reviews
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    '$rating ($reviews reviews)',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,

                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Description Header
              Text(
                'Description',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,

                ),
              ),
              const SizedBox(height: 10),
              // Description Content
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  description,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    height: 1.5,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add to cart functionality
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Favorite functionality
                    },
                    icon: const Icon(Icons.favorite_border),
                    label: const Text('Add to Wishlist'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.primaryColor),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
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
  }
}
