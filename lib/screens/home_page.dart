import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/market_store.dart';
import 'product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _openCart() async {
    await context.pushNamed('cart');
    if (mounted) setState(() {});
  }

  Future<void> _openProduct(String id) async {
    await context.pushNamed(
      'productDetails',
      pathParameters: {'id': id},
    );
    if (mounted) setState(() {});
  }

  Future<void> _openProductForm() async {
    await context.pushNamed('addProduct');
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = MarketStore.cartCount;
    final products = MarketStore.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mini Market',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _openCart,
            icon: Badge(
              isLabelVisible: itemCount > 0,
              label: Text(itemCount.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: products.isEmpty
          ? const Center(
              child: Text(
                'No products yet.\nTap + to add your first one.',
                textAlign: TextAlign.center,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    product: product,
                    onTap: () => _openProduct(product.id),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openProductForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
