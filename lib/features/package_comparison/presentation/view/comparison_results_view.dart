import 'package:doc_diff/features/package_comparison/presentation/manager/comparison_cubit/comparison_cubit.dart';
import 'package:doc_diff/features/package_comparison/presentation/manager/comparison_cubit/comparison_state.dart';
import 'package:doc_diff/features/package_comparison/presentation/widgets/comparison_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComparisonResultsView extends StatefulWidget {
  const ComparisonResultsView({super.key});

  @override
  State<ComparisonResultsView> createState() => _ComparisonResultsViewState();
}

class _ComparisonResultsViewState extends State<ComparisonResultsView> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search PDFs...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ComparisonResults(
                result: state.result,
                searchQuery: _searchQuery,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
