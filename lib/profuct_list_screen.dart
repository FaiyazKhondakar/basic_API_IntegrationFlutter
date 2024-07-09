import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rest_api_flutter/add_new_product_screen.dart';
import 'package:rest_api_flutter/edit_product_screen.dart';
import 'package:rest_api_flutter/product.dart';

enum PopUpMenuType { edit, delete }

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}
class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productList = [];
  bool _inProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductListFromApi();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getProductListFromApi();
        },
        child: Visibility(
          visible: _inProgress == false,
          replacement: const Center(child: CircularProgressIndicator()),
          child: ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return buildProductListTile(index);
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddNewProductScreen()));
        },
        label: const Row(
          children: [
            Icon(
              Icons.add,
              size: 20,
            ),
            // SizedBox(width: 5,),
            Text(
              'Add',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapPopupMenuButton(PopUpMenuType type,Product product ) {
    if (type == PopUpMenuType.edit) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => EditProductScreen(product: product,)));
    } else if (type == PopUpMenuType.delete) {
      _showDeleteDialog(product.id.toString());
    }
  }

  void _showDeleteDialog(String productId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete !'),
            content: const Text('Are you sure you want to delete this product'),
            actions: [
              TextButton(
                  onPressed: () {
                    deleteProduct(productId);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Yes! Delete',
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
            ],
          );
        });
  }

  ListTile buildProductListTile(index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            productList[index].image ?? ''),
      ),
      trailing: PopupMenuButton<PopUpMenuType>(
        onSelected: (selectedMenu) {
          _onTapPopupMenuButton(selectedMenu , productList[index]);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<PopUpMenuType>>[
          const PopupMenuItem(
            value: PopUpMenuType.edit,
            child: Row(
              children: [
                Icon(Icons.edit),
                SizedBox(
                  width: 8,
                ),
                Text('Edit'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: PopUpMenuType.delete,
            child: Row(
              children: [
                Icon(Icons.delete),
                SizedBox(
                  width: 8,
                ),
                Text('Delete'),
              ],
            ),
          ),
        ],
      ),
      title: Text(productList[index].productName ?? 'Unknown'),
      subtitle: Wrap(
        spacing: 16,
        children: [
          Text(productList[index].productCode ?? 'Unknown'),
          Text(productList[index].unitPrice ?? 'Unknown'),
          Text(productList[index].totalPrice ?? 'Unknown'),
          Text(productList[index].quantity ?? 'Unknown'),
        ],
      ),
    );
  }

  Future<void> getProductListFromApi() async {
    _inProgress = true;
    setState(() {});

    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/ReadProduct');
    Response response = await get(uri);
    if(response.statusCode ==200){
      productList.clear();
      var decodeResponse = jsonDecode(response.body);
      if(decodeResponse['status'] == 'success'){
        var list = decodeResponse['data'];
        for(var item in list){
          Product product = Product.fromJson(item);
          productList.add(product);
        }
      }
      _inProgress = false;
      setState(() {});
    }

  }

  Future<void> deleteProduct(String productId) async {
    _inProgress = true;
    setState(() {});

    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/DeleteProduct/$productId');
    Response response = await get(uri);
    if(response.statusCode ==200){
      productList.removeWhere((element) => element.id == productId);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delete successful')));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong! please try again')));
    }
    _inProgress= false;
    setState(() {});
  }


}

