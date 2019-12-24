import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:scheduler/data/dbManager.dart';
import 'package:scheduler/data/models/category.dart';
import 'catSearch.dart';

class CatBloc extends Bloc<CatEvent, CatState> {
  final DbManager dbManager;

  CatBloc({@required this.dbManager});
  
  @override
  CatState get initialState => CatLoading();

  @override
  Stream<CatState> mapEventToState(
    CatEvent event,
  ) async* {
    if (event is LoadCat) {
      yield* _mapLoadCatToState();
    }
    else if (event is AddCat) {
      yield* _mapAddCatToState(event);
    }
    else if (event is UpdateCat) {
      yield* _mapUpdateCatToState(event);
    }
    else if (event is DeleteCat) {
      yield* _mapDeleteCatToState(event);
    } 
  }
  Stream<CatState> _mapLoadCatToState() async* {
    try {
      final cats = await this.dbManager.getAllCategory();
      yield CatLoaded(cats);
    } catch (_) {
      yield CatNotLoaded();
    }
  }

  Stream<CatState> _mapAddCatToState(AddCat event) async* {
    if (state is CatLoaded) {
      final List<Category> updatedCat = List.from((state as CatLoaded).cats)
        ..add(event.cat);
      yield CatLoaded(updatedCat);
      dbManager.insertCategory(event.cat);
    }
  }

  Stream<CatState> _mapUpdateCatToState(UpdateCat event) async* {
    if (state is CatLoaded) {
      final List<Category> updatedCat = (state as CatLoaded).cats.map((category) {
        return category.id == event.updatedCat.id ? event.updatedCat : category;
      }).toList();
      yield CatLoaded(updatedCat);
      dbManager.updateCategory(event.updatedCat);
    }
  }

  Stream<CatState> _mapDeleteCatToState(DeleteCat event) async* {
    if (state is CatLoaded) {
      final updatedCat = (state as CatLoaded)
          .cats
          .where((category) => category.id != event.id)
          .toList();
      yield CatLoaded(updatedCat);
      dbManager.deleteCategory(event.id);
    }
  }
}