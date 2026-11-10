import 'package:doc_diff_app/features/comparison/presentation/widgets/home_body.dart';
import 'package:doc_diff_app/features/comparison/presentation/widgets/home_header.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFF4F7F9),
      body: Column(
        children: [
          HomeHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: HomeBody(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
