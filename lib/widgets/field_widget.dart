import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/widgets/field_bloc.dart';

class FieldWidget extends StatelessWidget {
  const FieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fieldBloc = FieldBloc();
    fieldBloc.showWinnerDialogCallback = showWinnerDialog;
    fieldBloc.add(InitFieldEvent());

    return BlocProvider(
      create: (context) => fieldBloc,
      child: Scaffold(
        backgroundColor: Colors.green.shade200,
        appBar: AppBar(
          title: Text('tic-tac-toe'.toUpperCase()),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Center(
            child: BlocBuilder<FieldBloc, List<Item>>(
              builder: (context, field) {
                return field.isEmpty
                    ? const CircularProgressIndicator()
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: field.length,
                        itemBuilder: (context, index) {
                          final item = field[index];
                          return GestureDetector(
                            onTap: () {
                              fieldBloc.add(
                                ItemEvent(
                                  item.index,
                                  item.icon,
                                  context,
                                  fieldBloc,
                                ),
                              );
                            },
                            child: Card(
                              key: Key('card_$index'),
                              color: item.color,
                              margin: const EdgeInsets.all(10),
                              child: Center(
                                child: Icon(
                                  item.icon,
                                  size: 64,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  void showWinnerDialog(
      BuildContext context, String winner, FieldBloc fieldBloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Winner: $winner"),
          actions: [
            TextButton(
              onPressed: () {
                fieldBloc.resetField();
                Navigator.of(context).pop();
              },
              child: const Text("Restart game"),
            ),
          ],
        );
      },
    );
  }
}
