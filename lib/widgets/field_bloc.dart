import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FieldBloc extends Bloc<FieldEvent, List<Item>> {
  Player currentPlayer = Player.cross;

  FieldBloc() : super([]) {
    on<GenerateFieldEvent>(_initField);
    on<ItemEvent>(_setItem);
  }

  _initField(GenerateFieldEvent event, Emitter<List<Item>> emit) async {
    try {
      final List<Item> field = [];
      currentPlayer = Player.cross;
      
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          final int index = row * 3 + col;
          field.add(Item(index: index));
        }
      }

      emit(field);
    } catch (e) {
      emit([]);
    }
  }

  _setItem(ItemEvent event, Emitter<List<Item>> emit) async {
    final int index = event.index;

    if (index >= 0 && index < state.length) {
      final int index = event.index;

      if (index >= 0 && index < state.length) {
        final item = state[index];

        if (item.icon == null) {
          if (currentPlayer == Player.cross) {
            item.icon = Icons.clear;
            item.color = Colors.green.shade300;
            currentPlayer = Player.circle;
          } else {
            item.icon = Icons.circle_outlined;
            item.color = Colors.red.shade300;
            currentPlayer = Player.cross;
          }
          emit(List.of(state));
        }
      }
    }
  }
}

abstract class FieldEvent {}

class GenerateFieldEvent extends FieldEvent {}

class ItemEvent extends FieldEvent {
  final int index;
  IconData? icon;

  ItemEvent(this.index, this.icon);
}

enum Player { cross, circle }

class Item {
  final int index;
  IconData? icon;
  Color? color;

  Item({
    required this.index,
    this.icon,
  });
}
