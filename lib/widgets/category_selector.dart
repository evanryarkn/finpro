import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Work', 'Personal', 'Proker'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: categories
          .map((category) => ChoiceChip(
                label: Text(category),
                selected: selectedCategory == category,
                onSelected: (_) => onCategoryChanged(category),
              ))
          .toList(),
    );
  }
}
