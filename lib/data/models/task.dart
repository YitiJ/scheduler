import 'package:equatable/equatable.dart';

class Task extends Equatable{
  int id;
  String name;
  String description;

  List<Object> get props => [id, name, description];

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
    this.id = null;
    this.name = name;
    this.description = description;
  }

}
