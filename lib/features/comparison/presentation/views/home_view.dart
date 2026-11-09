import 'package:doc_diff_app/core/utils/adaptive_layouts.dart';
import 'package:doc_diff_app/features/comparison/presentation/layouts/desktop_home_layout.dart';
import 'package:doc_diff_app/features/comparison/presentation/layouts/mobile_home_layout.dart';
import 'package:doc_diff_app/features/comparison/presentation/layouts/tablet_home_layout.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdaptiveLayout(
        mobileLayout: (context) => DesktopHomeLayout(),
        tabletLayout: (context) => TabletHomeLayout(),
        desktopLayout: (context) => MobileHomeLayout(),
      ),
    );
  }
}
