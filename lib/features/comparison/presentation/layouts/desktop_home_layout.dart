import 'package:doc_diff_app/features/comparison/presentation/widgets/home_header.dart';
import 'package:flutter/material.dart';

class DesktopHomeLayout extends StatelessWidget {
  const DesktopHomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        HomeHeader(),
      ],
    );
  }
}