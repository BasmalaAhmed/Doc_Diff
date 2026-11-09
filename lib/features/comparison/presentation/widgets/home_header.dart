import 'package:doc_diff_app/core/utils/logo_widget.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: const BoxDecoration(
        color: Color(0XFFFDFEFE),
        border: Border(bottom: BorderSide(color: Color(0XFFDDE2E6))),
      ),
      child: const Row(
        children: [
          LogoWidget(),
          SizedBox(width: 6),
          Text(
            'DocDiff',
            style: TextStyle(
              color: Color(0XFF000C19),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
