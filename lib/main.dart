import 'package:doc_diff/features/package_comparison/presentation/view/home_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DocDiffApp());
}

class DocDiffApp extends StatelessWidget {
  const DocDiffApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DocDiff',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo,),
        useMaterial3: true,
      ),
      home: const HomeView(),
    );
  }
}
