import 'package:equatable/equatable.dart';

class Task extends Equatable{
  final int id;
  String name;
  String description;
  bool isDeleted;

  List<Object> get props => [id, name, description,isDeleted];

  static fromMap(Map<String,dynamic> map){
    return new Task(map["id"], map["name"], map["description"], map["isDeleted"]);
  }

  Map<String, dynamic> toMap() {
    return {
    "id": id,
    "name": name,
    "description": description,
    "isDeleted": isDeleted? 1:0
    };
  }

  Task(this.id, this.name, this.description, int isDeleted){this.isDeleted = (isDeleted == 1) ? true:false;}
  Task.newTask(String name, String description): id = null{
    this.name = name;
    this.description = description == null? "" : description;
    this.isDeleted = false;
  }

}
