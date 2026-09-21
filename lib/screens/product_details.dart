import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_page.dart';
import '../screens/cart_page.dart';
import '../screens/product_details.dart';
import '../screens/add_product.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    // HOME
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) {
        return const HomePage();
      },
    ),

    // CART
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (context, state) {
        return const CartPage();
      },
    ),

    // ADD PRODUCT
    GoRoute(
      path: '/products/new',
      name: 'addProduct',
      builder: (context, state) {
        return const AddProduct();
      },
    ),

    // PRODUCT DETAILS
    GoRoute(
      path: '/products/:id',
      name: 'productDetails',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;

        return ProductDetails(productId: productId);
      },
    ),
  ],
);
