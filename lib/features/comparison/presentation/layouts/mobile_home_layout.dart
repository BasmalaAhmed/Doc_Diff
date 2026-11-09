import 'package:doc_diff_app/features/comparison/presentation/widgets/home_header.dart';
import 'package:flutter/material.dart';

class MobileHomeLayout extends StatelessWidget {
  const MobileHomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        HomeHeader(),
      ],
    );
  }
}