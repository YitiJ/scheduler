import 'package:equatable/equatable.dart';

abstract class DbModel extends Equatable{
  final int id;
  DbModel(this.id);
}