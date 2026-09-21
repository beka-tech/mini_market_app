import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/add_product.dart';
import '../screens/cart_page.dart';
import '../screens/home_page.dart';
import '../screens/product_details.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (context, state) => const CartPage(),
    ),
    GoRoute(
      path: '/products/new',
      name: 'addProduct',
      builder: (context, state) => const AddProduct(),
    ),
    GoRoute(
      path: '/products/:id',
      name: 'productDetails',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductDetails(productId: productId);
      },
    ),
    GoRoute(
      path: '/products/:id/edit',
      name: 'editProduct',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return AddProduct(productId: productId);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);
