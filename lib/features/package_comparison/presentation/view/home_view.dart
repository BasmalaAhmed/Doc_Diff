import 'package:doc_diff/core/services/file_picker_service.dart';
import 'package:doc_diff/features/package_comparison/presentation/manager/comparison_cubit/comparison_cubit.dart';
import 'package:doc_diff/features/package_comparison/presentation/manager/comparison_cubit/comparison_state.dart';
import 'package:doc_diff/features/package_comparison/presentation/view/comparison_results_view.dart';
import 'package:doc_diff/features/package_comparison/presentation/widgets/package_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FilePickerService _filePickerService = FilePickerService();

  String? _originalPackagePath;
  String? _updatedPackagePath;

  Future<void> _pickOriginalPackage() async {
    final path = await _filePickerService.pickDirectory();

    if (path == null) return;

    setState(() {
      _originalPackagePath = path;
    });
  }

  Future<void> _pickUpdatedPackage() async {
    final path = await _filePickerService.pickDirectory();

    if (path == null) return;

    setState(() {
      _updatedPackagePath = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ComparisonCubit, ComparisonState>(
      listener: (context, state) {
        if (state is ComparisonSuccess) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ComparisonResultsView()),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  'DocDiff',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Compare document packages and find what changed.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: PackageCard(
                          title: 'Original Package',
                          subtitle: 'Select the original package',
                          icon: Icons.folder_outlined,
                          selectedPath: _originalPackagePath,
                          onSelect: _pickOriginalPackage,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: PackageCard(
                          title: 'Updated Package',
                          subtitle: 'Select the updated package',
                          icon: Icons.folder_copy_outlined,
                          selectedPath: _updatedPackagePath,
                          onSelect: _pickUpdatedPackage,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  height: 50,
                  width: 350,
                  child: FilledButton.icon(
                    onPressed: () {
                      if (_originalPackagePath == null ||
                          _updatedPackagePath == null) {
                        return;
                      }

                      context.read<ComparisonCubit>().comparePackages(
                        originalPackagePath: _originalPackagePath!,
                        updatedPackagePath: _updatedPackagePath!,
                      );
                    },
                    icon: const Icon(Icons.compare_arrows),
                    label: const Text('Compare Packages'),
                  ),
                ),

                const SizedBox(height: 24),

                BlocBuilder<ComparisonCubit, ComparisonState>(
                  builder: (context, state) {
                    if (state is ComparisonLoading) {
                      return const Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('Comparing packages...'),
                        ],
                      );
                    }
                    if (state is ComparisonFailure) {
                      return Text(
                        state.message,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
