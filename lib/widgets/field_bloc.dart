import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FieldBloc extends Bloc<FieldEvent, List<Item>> {
  Player currentPlayer = Player.cross;

  late void Function(BuildContext context, String winner, FieldBloc fieldBloc)
      showWinnerDialogCallback;

  FieldBloc() : super([]) {
    on<InitFieldEvent>(_initField);
    on<ItemEvent>(_setItem);
  }

  void resetField() {
    add(InitFieldEvent());
  }

  bool isDraw(List<Item> field) {
    for (final item in field) {
      if (item.icon == null) {
        return false;
      }
    }
    return true;
  }

  bool checkWinner(IconData icon, List<Item> field) {
    for (int row = 0; row < 3; row++) {
      if (field[row * 3].icon == icon &&
          field[row * 3 + 1].icon == icon &&
          field[row * 3 + 2].icon == icon) {
        return true;
      }
    }

    for (int col = 0; col < 3; col++) {
      if (field[col].icon == icon &&
          field[col + 3].icon == icon &&
          field[col + 6].icon == icon) {
        return true;
      }
    }

    if ((field[0].icon == icon &&
            field[4].icon == icon &&
            field[8].icon == icon) ||
        (field[2].icon == icon &&
            field[4].icon == icon &&
            field[6].icon == icon)) {
      return true;
    }

    return false;
  }

  _initField(InitFieldEvent event, Emitter<List<Item>> emit) async {
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

          if (checkWinner(Icons.clear, state)) {
            showWinnerDialogCallback(
              event.context,
              "Cross",
              event.fieldBloc,
            );
          } else if (checkWinner(Icons.circle_outlined, state)) {
            showWinnerDialogCallback(
              event.context,
              "Circle",
              event.fieldBloc,
            );
          } else if (isDraw(state)) {
            showWinnerDialogCallback(
              event.context,
              "Draw",
              event.fieldBloc,
            );
          }
        }
      }
    }
  }
}

abstract class FieldEvent {}

class InitFieldEvent extends FieldEvent {}

class ItemEvent extends FieldEvent {
  final int index;
  IconData? icon;
  BuildContext context;
  FieldBloc fieldBloc;

  ItemEvent(this.index, this.icon, this.context, this.fieldBloc);
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
