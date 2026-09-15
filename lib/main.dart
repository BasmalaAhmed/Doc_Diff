import 'package:doc_diff/core/service_locator.dart';
import 'package:doc_diff/features/package_comparison/presentation/manager/comparison_cubit/comparison_cubit.dart';
import 'package:doc_diff/features/package_comparison/presentation/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  setupServiceLocator();
  runApp(const DocDiffApp());
}

class DocDiffApp extends StatelessWidget {
  const DocDiffApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComparisonCubit(sl(), sl()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DocDiff',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const HomeView(),
      ),
    );
  }
}
