import 'dart:typed_data';

import 'package:flutter/material.dart';

class ComparisonImage extends StatelessWidget {
  const ComparisonImage({super.key, required this.title, required this.image});

  final String title;
  final Uint8List? image;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: image == null
              ? const SizedBox(
                  height: 200,
                  child: Center(child: Text('Not Available')),
                )
              : Image.memory(image!, fit: BoxFit.contain),
        ),
      ],
    );
  }
}
