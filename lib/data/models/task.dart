import 'package:scheduler/data/models/dbModel.dart';

class Task extends DbModel{
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

  Task(int id, this.name, this.description, int isDeleted) :super(id)
    {this.isDeleted = (isDeleted == 1) ? true:false;}
  Task.newTask(String name, String description): super(null){
    this.name = name;
    this.description = description == null? "" : description;
    this.isDeleted = false;
  }

}
