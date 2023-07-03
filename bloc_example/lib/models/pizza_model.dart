import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Pizza extends Equatable {
  final String id;
  final String name;
  final Image image;

  final double left;
  final double top;

  static final Random random = Random();

  const Pizza({
    required this.id,
    required this.name,
    required this.image,
    required this.left,
    required this.top,
  });

  Pizza.atRandomPos()
      : id = '0',
        name = 'Pizza',
        image = Image.asset('images/pizza.png'),
        left = random.nextInt(250).toDouble(),
        top = random.nextInt(400).toDouble();

  @override
  List<Object?> get props => [id, name, image];
}
