import 'package:equatable/equatable.dart';

abstract class DbModel extends Equatable{
  int id;
  DbModel(this.id);
}