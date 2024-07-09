import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _addNewProductInProgress =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: buildAddProductForm(),
        ),
      ),
    );
  }

  Form buildAddProductForm() {
    return Form(
      key: _formKey,  // Assigning the key to the Form widget
      child: Column(
        children: [
          TextFormField(
            validator: (value) => _formValidation(value, 'Product Name'),
            controller: _nameTEController,
            decoration: const InputDecoration(
              hintText: 'Enter Product Name',
              label: Text('Product Name'),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            validator: (value) => _formValidation(value, 'Product Code'),
            controller: _codeTEController,
            decoration: const InputDecoration(
              hintText: 'Enter Product Code',
              label: Text('Product Code'),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            validator: (value) => _formValidation(value, 'Unit Price'),
            controller: _unitPriceTEController,
            decoration: const InputDecoration(
              hintText: 'Enter Unit Price',
              label: Text('Unit Price'),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            validator: (value) => _formValidation(value, 'Quantity'),
            controller: _quantityTEController,
            decoration: const InputDecoration(
              hintText: 'Enter Quantity',
              label: Text('Quantity'),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            validator: (value) => _formValidation(value, 'Total Price'),
            controller: _totalPriceTEController,
            decoration: const InputDecoration(
              hintText: 'Enter Total Price',
              label: Text('Total Price'),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            validator: (value) => _formValidation(value, 'Image URL'),
            controller: _imageTEController,
            decoration: const InputDecoration(
              hintText: 'Enter Image URL',
              label: Text('Image'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: Visibility(
              visible: _addNewProductInProgress == false,
              replacement: const Center(child: CircularProgressIndicator()),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    createNewProduct();
                  }
                },
                child: const Text('Add'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _formValidation(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your $fieldName';
    }
    return null;
  }

  Future<void> createNewProduct() async {

    _addNewProductInProgress =true;
    setState(() {});
    Uri uri = Uri.parse("https://crud.teamrabbil.com/api/v1/CreateProduct");

    Map<String, dynamic> params = {
      "Img": _imageTEController.text.trim(),
      "ProductCode": _codeTEController.text.trim(),
      "ProductName": _nameTEController.text.trim(),
      "Qty": _quantityTEController.text.trim(),
      "TotalPrice": _totalPriceTEController.text.trim(),
      "UnitPrice": _unitPriceTEController.text.trim()
    };

    Response response = await post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(params)
    );

    if (response.statusCode == 200) {
      _imageTEController.clear();
      _codeTEController.clear();
      _nameTEController.clear();
      _quantityTEController.clear();
      _totalPriceTEController.clear();
      _unitPriceTEController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product added successful')));

    }
    _addNewProductInProgress =false;
    setState(() {});
  }
  @override
  void dispose() {
    _imageTEController.dispose();
    _codeTEController.dispose();
    _nameTEController.dispose();
    _quantityTEController.dispose();
    _totalPriceTEController.dispose();
    _unitPriceTEController.dispose();
    super.dispose();
  }

}
