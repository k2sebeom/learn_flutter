import 'package:bloc_example/blocs/pizza/pizza_bloc.dart';
import 'package:bloc_example/models/pizza_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => PizzaBloc()..add(LoadPizzaCounter()))
      ],
      child: const MaterialApp(
        title: 'Bloc Demo',
        home: HomeScreeen(),
      ),
    );
  }
}

class HomeScreeen extends StatelessWidget {
  const HomeScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Pizza Bloc'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: BlocBuilder<PizzaBloc, PizzaState>(
          builder: (ctx, state) {
            if (state is PizzaInitial) {
              return const CircularProgressIndicator(
                color: Colors.orange,
              );
            }
            if (state is PizzaLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${state.pizzas.length}',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(ctx).size.height / 1.5,
                    width: MediaQuery.of(ctx).size.width,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        for (int i = 0; i < state.pizzas.length; i++)
                          Positioned(
                              left: state.pizzas[i].left,
                              top: state.pizzas[i].top,
                              child: SizedBox(
                                width: 150,
                                height: 150,
                                child: state.pizzas[i].image,
                              ))
                      ],
                    ),
                  )
                ],
              );
            } else {
              return const Text('Something went wrong!');
            }
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: () {
              context.read<PizzaBloc>().add(AddPizza(
                    pizza: Pizza.atRandomPos(),
                  ));
            },
            child: const Icon(Icons.local_pizza_outlined),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: () {
              context.read<PizzaBloc>().add(RemovePizza());
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
