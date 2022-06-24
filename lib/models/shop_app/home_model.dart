class HomeModel {
  bool? status;
  HomeDataModel? data;

  HomeModel.fromJSON(Map<String, dynamic> json) {
    status = json['status'];
    data = HomeDataModel.fromJSON(json['data']);
  }

  @override
  String toString() {
    return '{Status: $status, Data: ${data.toString()}}';
  }
}

class HomeDataModel {
  List<BannerModel> banners = [];
  List<ProductModel> products = [];

  HomeDataModel.fromJSON(Map<String, dynamic> json) {
    json['banners'].forEach((element) {
      banners.add(BannerModel.fromJSON(element));
    });

    json['products'].forEach((element) {
      products.add(ProductModel.fromJSON(element));
    });
  }

  @override
  String toString() {
    return '{Banners: ${banners.toString()}, Products: ${products.toString()}}';
  }
}

class BannerModel {
  int? id;
  String? image;

  BannerModel.fromJSON(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  @override
  String toString() {
    return '{Id: $id, Image: $image}';
  }
}

class ProductModel {
  int? id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String? image;
  String? name;
  bool? inFavorites;
  bool? inCart;

  ProductModel.fromJSON(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }

  @override
  String toString() {
    return '{Id: $id, Price: $price, Old Price: $oldPrice, Discount: $discount, Image: $image, Name: $name, In Favorites: $inFavorites, In Cart: $inCart}';
  }
}
