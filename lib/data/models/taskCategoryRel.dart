import 'package:scheduler/data/models/dbModel.dart';

class TaskCategoryRel extends DbModel{
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

  TaskCategoryRel(int id, this.taskID, this.categoryID): super(id);

  TaskCategoryRel.newRelation(int taskID, int categoryID) : super(null){
    this.categoryID = categoryID;
    this.taskID = taskID;
  }

}
