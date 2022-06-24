class CategoriesModel {
  bool? status;
  CategoriesDataModel? data;

  CategoriesModel.fromJSON(Map<String, dynamic> json) {
    status = json['status'];
    data = CategoriesDataModel.fromJSON(json['data']);
  }

  @override
  String toString() {
    return '{Status: $status, Data: ${data.toString()}}';
  }
}

class CategoriesDataModel {
  List<DataModel> data = [];

  CategoriesDataModel.fromJSON(Map<String, dynamic> json) {
    json['data'].forEach((element) {
      data.add(DataModel.fromJSON(element));
    });
  }

  @override
  String toString() {
    return '{Banners: ${data.toString()}}';
  }
}

class DataModel {
  int? id;
  String? name;
  String? image;

  DataModel.fromJSON(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  @override
  String toString() {
    return '{Id: $id, Name: $name, Image: $image}';
  }
}
