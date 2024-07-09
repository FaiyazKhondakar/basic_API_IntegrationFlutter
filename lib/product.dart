class Product{
  String? id;
  String? productName;
  String? productCode;
  String? image;
  String? unitPrice;
  String? quantity;
  String? totalPrice;
  String? createdDate;

  Product({
    this.id,
    this.productName,
    this.productCode,
    this.image,
    this.unitPrice,
    this.quantity,
    this.totalPrice,
    this.createdDate,
});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    productName = json['ProductName'];
    productCode = json['ProductCode'];
    image = json['Img'];
    unitPrice = json['UnitPrice'];
    quantity = json['Qty'];
    totalPrice = json['TotalPrice'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['ProductName'] = productName;
    data['ProductCode'] = productCode;
    data['Img'] = image;
    data['UnitPrice'] = unitPrice;
    data['Qty'] = quantity;
    data['TotalPrice'] = totalPrice;
    data['CreatedDate'] = createdDate;
    return data;
  }


}