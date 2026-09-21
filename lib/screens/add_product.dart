import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/categories.dart';
import '../data/market_store.dart';
import '../models/product.dart';

class AddProduct extends StatefulWidget {
  final String? productId;

  const AddProduct({super.key, this.productId});

  bool get isEditing => productId != null;

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _category = kCategories.first;

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      final product = MarketStore.findProduct(widget.productId!);
      if (product != null) {
        _titleController.text = product.title;
        _priceController.text = product.price.toStringAsFixed(1);
        _descriptionController.text = product.description;
        _category = product.category;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final price = double.parse(_priceController.text.trim());

    if (widget.productId == null) {
      MarketStore.addProduct(
        Product(
          id: MarketStore.newProductId(),
          title: _titleController.text.trim(),
          price: price,
          category: _category,
          description: _descriptionController.text.trim(),
        ),
      );
    } else {
      final old = MarketStore.findProduct(widget.productId!);
      if (old == null) return;
      MarketStore.updateProduct(
        old.copyWith(
          title: _titleController.text.trim(),
          price: price,
          category: _category,
          description: _descriptionController.text.trim(),
        ),
      );
    }

    context.pop();
  }

  InputDecoration _decoration() {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit product' : 'Add product',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Title'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: _decoration(),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a title'
                      : null,
                ),
                const SizedBox(height: 22),
                const Text('Price'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: _decoration(),
                  validator: (value) {
                    final price = double.tryParse(value?.trim() ?? '');
                    if (price == null || price < 0) return 'Enter a valid price';
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                const Text('Category'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: _decoration(),
                  items: kCategories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _category = value);
                  },
                ),
                const SizedBox(height: 22),
                const Text('Description'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 4,
                  maxLines: 4,
                  decoration: _decoration(),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a description'
                      : null,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: _save,
                    child: Text(
                      widget.isEditing ? 'Save changes' : 'Save product',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
