import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rest_api_flutter/product.dart';
import 'package:rest_api_flutter/profuct_list_screen.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key, required this.product});

  final Product product;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _updateProductInProgress = false;

  @override
  void initState() {
    super.initState();
    _nameTEController.text = widget.product.productName ?? '';
    _codeTEController.text = widget.product.productCode ?? '';
    _unitPriceTEController.text = widget.product.unitPrice ?? '';
    _quantityTEController.text = widget.product.quantity ?? '';
    _totalPriceTEController.text = widget.product.totalPrice ?? '';
    _imageTEController.text = widget.product.image ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: buildEditProductForm(),
        ),
      ),
    );
  }

  Form buildEditProductForm() {
    return Form(
      key: _formKey,
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
          Visibility(
            visible: _updateProductInProgress == false,
            replacement: const Center(child: CircularProgressIndicator()),
            child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        updateProduct();
                      }
                    },
                    child: const Text('Update'))),
          )
        ],
      ),
    );
  }

  String? _formValidation(String? value, String fieldName) {
    if (value?.trim().isEmpty ?? true) {
      return 'Enter your $fieldName';
    }
    return null;
  }

  Future<void> updateProduct() async {
    _updateProductInProgress = true;
    setState(() {});

    Uri uri = Uri.parse(
        'https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}');

    Product product  =Product(
      id: widget.product.id,
      productName: _nameTEController.text.trim(),
      productCode: _codeTEController.text.trim(),
      image: _imageTEController.text.trim(),
      unitPrice: _unitPriceTEController.text.trim(),
      quantity: _quantityTEController.text.trim(),
      totalPrice: _totalPriceTEController.text.trim(),
    );

    // Map<String, dynamic> params = {
    //   "Img": _imageTEController.text.trim(),
    //   "ProductCode": _codeTEController.text.trim(),
    //   "ProductName": _nameTEController.text.trim(),
    //   "Qty": _quantityTEController.text.trim(),
    //   "TotalPrice": _totalPriceTEController.text.trim(),
    //   "UnitPrice": _unitPriceTEController.text.trim(),
    // };

    Response response = await post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode == 200) {
      final decodeData = jsonDecode(response.body);
      if (decodeData['status'] == 'success') {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product update failed! Try again.')));
        _updateProductInProgress = false;
        setState(() {});
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product update failed! Try again.')));
      _updateProductInProgress = false;
      setState(() {});
    }

  }

  @override
  void dispose() {
    super.dispose();
    _nameTEController.dispose();
    _codeTEController.dispose();
    _unitPriceTEController.dispose();
    _quantityTEController.dispose();
    _totalPriceTEController.dispose();
    _imageTEController.dispose();

  }
}
