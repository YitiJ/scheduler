import 'package:scheduler/data/models/dbModel.dart';

class Category extends DbModel {
  int type;
  String name;
  
  @override
  List<Object> get props => [id, type, name];
  
  static fromMap(Map<String,dynamic> map){
    return new Category(map["id"], map["name"], map["type"]);
  }

  Map<String, dynamic> toMap() {
    return {
    "id": id,
    "name": name,
    "type": type,
    };
  }

  Category(int id, this.name,this.type) :super(id);
  Category.newCategory(String name,int type):super(null){
    this.name = name;
    this.type = type;
  }

}
