class TaskCategoryRel {
  int id;
  int taskID;
  int categoryID;

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
    id = -1;
    this.categoryID = categoryID;
    this.taskID = taskID;
  }

}