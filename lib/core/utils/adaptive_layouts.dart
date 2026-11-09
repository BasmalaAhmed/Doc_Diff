import 'package:flutter/material.dart';

class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    super.key,
    required this.mobileLayout,
    required this.tabletLayout,
    required this.desktopLayout,
  });

  final WidgetBuilder mobileLayout, tabletLayout, desktopLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        if (constrains.maxWidth < 640) {
          return mobileLayout(context);
        }
        else if (constrains.maxWidth < 768) {
          return tabletLayout(context);
        }
        else {
          return desktopLayout(context);
        }
      },
    );
  }
}