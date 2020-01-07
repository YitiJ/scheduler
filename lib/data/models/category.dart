import 'package:scheduler/data/models/dbModel.dart';

class Category extends DbModel {
  String name;
  
  static Category none(){
    return new Category(0,"None");
  }
  
  @override
  List<Object> get props => [id, name];
  
  static fromMap(Map<String,dynamic> map){
    return new Category(map["id"], map["name"]);
  }

  Map<String, dynamic> toMap() {
    return {
    "id": id,
    "name": name,
    };
  }

  Category(int id, this.name) :super(id);
  Category.newCategory(String name):super(null){
    this.name = name;
  }

}
