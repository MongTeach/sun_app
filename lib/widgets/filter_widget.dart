import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            // Logika untuk filter
          },
        ),
        const Text(
          'Filter',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
