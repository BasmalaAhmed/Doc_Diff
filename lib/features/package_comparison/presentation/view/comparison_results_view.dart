import 'package:doc_diff/features/package_comparison/presentation/manager/comparison_cubit/comparison_cubit.dart';
import 'package:doc_diff/features/package_comparison/presentation/manager/comparison_cubit/comparison_state.dart';
import 'package:doc_diff/features/package_comparison/presentation/widgets/comparison_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComparisonResultsView extends StatelessWidget {
  const ComparisonResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ComparisonCubit>().state;

    if (state is! ComparisonSuccess) {
      return const Scaffold(
        body: Center(child: Text('No comparison results available.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Comparison Results')),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: ComparisonResults(result: state.result),
      ),
    );
  }
}
