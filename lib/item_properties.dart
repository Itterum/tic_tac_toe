import 'package:flutter/material.dart';

enum Items { X, O, none }

class ItemProperties {
  final IconData icon;
  final Color bgColor;
  final Color brColor;

  ItemProperties({
    required this.icon,
    required this.bgColor,
    required this.brColor,
  });
}

Map<Items, ItemProperties> itemMap = {
  Items.X: ItemProperties(
    icon: Icons.clear,
    bgColor: Colors.green.shade300,
    brColor: Colors.green.shade300,
  ),
  Items.O: ItemProperties(
    icon: Icons.circle_outlined,
    bgColor: Colors.red.shade300,
    brColor: Colors.red.shade300,
  ),
};
