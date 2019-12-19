import 'package:equatable/equatable.dart';

class TaskCategoryRel extends Equatable{
  int id;
  int taskID;
  int categoryID;

  List<Object> get props => [id, taskID, categoryID];

  static fromMap(Map<String,dynamic> map){
    return new TaskCategoryRel(map["id"], map["taskID"], map["categoryID"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "taskID": taskID,
      "categoryID": categoryID
    };
  }

  TaskCategoryRel(this.id, this.taskID, this.categoryID);

  TaskCategoryRel.newRelation(int taskID, int categoryID){
    id = null;
    this.categoryID = categoryID;
    this.taskID = taskID;
  }

}
