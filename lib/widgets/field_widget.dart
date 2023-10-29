import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/widgets/field_bloc.dart';

class FieldWidget extends StatelessWidget {
  const FieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fieldBloc = FieldBloc();
    fieldBloc.add(GenerateFieldEvent());

    return BlocProvider(
      create: (context) => fieldBloc,
      child: Scaffold(
        backgroundColor: Colors.green.shade200,
        appBar: AppBar(),
        body: Center(
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
                          onTap: () => fieldBloc.add(
                            ItemEvent(item.index, item.icon),
                          ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            fieldBloc.add(GenerateFieldEvent());
          },
          tooltip: 'Restart game',
          child: const Icon(Icons.restart_alt_rounded),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
