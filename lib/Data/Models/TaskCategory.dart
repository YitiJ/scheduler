class TaskCategory {
  int id;
  String name;
  static fromMap(Map<String,dynamic> map){
    return new TaskCategory(map["id"], map["name"]);
  }

  Map<String, dynamic> toMap() {
    return {
    "id": id,
    "name": name,
    };
  }

  TaskCategory(this.id, this.name);
  TaskCategory.newTaskCategory(String name){
    this.id = -1;
    this.name = name;
  }

}