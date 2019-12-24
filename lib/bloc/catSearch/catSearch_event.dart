import 'package:equatable/equatable.dart';
import 'package:scheduler/data/models/category.dart';
import 'package:scheduler/data/models/task.dart';

abstract class CatEvent extends Equatable {
  const CatEvent();
  @override
  List<Object> get props => [];
}

class LoadCat extends CatEvent{

}

class AddCat extends CatEvent {
  final Category cat;

  const AddCat(this.cat);

  @override
  List<Object> get props => [cat];

  @override
  String toString() => 'AddCat { cat: $cat }';
}

class UpdateCat extends CatEvent {
  final Category updatedCat;

  const UpdateCat(this.updatedCat);

  @override
  List<Object> get props => [updatedCat];

  @override
  String toString() => 'UpdateCat { updatedCat: $updatedCat }';
}

class DeleteCat extends CatEvent {
  final int id;

  const DeleteCat(this.id);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'DeleteCat { DeleteCat: $id }';
}