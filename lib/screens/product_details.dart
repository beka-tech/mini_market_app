import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/categories.dart';
import '../data/market_store.dart';

class ProductDetails extends StatefulWidget {
  final String productId;

  const ProductDetails({super.key, required this.productId});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;

  Future<void> _editProduct() async {
    await context.pushNamed(
      'editProduct',
      pathParameters: {'id': widget.productId},
    );
    if (mounted) setState(() {});
  }

  Future<void> _deleteProduct() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete product?'),
        content: const Text('This product will be removed from the market.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      MarketStore.deleteProduct(widget.productId);
      if (mounted) context.pop();
    }
  }

  void _addToCart() {
    final product = MarketStore.findProduct(widget.productId);
    if (product == null) return;

    MarketStore.addToCart(product, quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.title} added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = MarketStore.findProduct(widget.productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Product not found.')),
      );
    }

    final productColor = colorForCategory(product.category);
    final productIcon = iconForCategory(product.category);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _editProduct,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: _deleteProduct,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 260,
                decoration: BoxDecoration(
                  color: productColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(productIcon, size: 90, color: productColor),
              ),
              const SizedBox(height: 30),
              Text(
                product.title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${product.price.toStringAsFixed(1)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                product.description,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Text('Qty', style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: quantity > 1
                        ? () => setState(() => quantity--)
                        : null,
                    child: const Icon(Icons.remove),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      quantity.toString(),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => setState(() => quantity++),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: _addToCart,
                  child: const Text(
                    'Add to cart',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
