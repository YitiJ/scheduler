class Task {
  int id;
  String name;
  String description;
  static fromMap(Map<String,dynamic> map){
    return new Task(map["id"], map["name"], map["description"]);
  }

  Map<String, dynamic> toMap() {
    return {
    "id": id,
    "name": name,
    "description": description,
    };
  }

  Task(this.id, this.name, this.description);
  Task.newTask(String name, String description){
    this.id = -1;
    this.name = name;
    this.description = description;
  }

}