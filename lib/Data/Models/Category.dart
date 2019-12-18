class Category {
  int id;
  int type;
  String name;
  static fromMap(Map<String,dynamic> map){
    return new Category(map["id"], map["name"], map["type"]);
  }

  Map<String, dynamic> toMap() {
    return {
    "id": id,
    "name": name,
    };
  }

  Category(this.id, this.name,this.type);
  Category.newCategory(String name,int type){
    this.id = -1;
    this.name = name;
    this.type = type;
  }

}