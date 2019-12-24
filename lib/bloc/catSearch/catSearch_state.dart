import 'package:equatable/equatable.dart';
import 'package:scheduler/data/models.dart';

abstract class CatState extends Equatable {
  const CatState();

  @override
  List<Object> get props => [];
}

class CatLoading extends CatState{}

class CatLoaded extends CatState{
  final List<Category> cats;

  const CatLoaded([this.cats = const []]);

  @override
  List<Object> get props => [cats];

  @override
  String toString() => 'CatLoaded { categories: $cats }';
}

class CatNotLoaded extends CatState{}