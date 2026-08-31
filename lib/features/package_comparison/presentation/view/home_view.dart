import 'package:doc_diff/core/services/file_picker_service.dart';
import 'package:doc_diff/features/package_comparison/data/models/package_file.dart';
import 'package:doc_diff/features/package_comparison/data/services/package_scanner.dart';
import 'package:doc_diff/features/package_comparison/presentation/widgets/package_card.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FilePickerService _filePickerService = FilePickerService();
  final PackageScanner _packageScanner = PackageScanner();

  List<PackageFile> _originalFiles = [];
  List<PackageFile> _updatedFiles = [];

  String? _originalPackagePath;
  String? _updatedPackagePath;

  Future<void> _pickOriginalPackage() async {
    final path = await _filePickerService.pickDirectory();

    if (path == null) return;

    final files = await _packageScanner.scan(path);

    setState(() {
      _originalPackagePath = path;
      _originalFiles = files;
    });
  }

  Future<void> _pickUpdatedPackage() async {
    final path = await _filePickerService.pickDirectory();

    if (path == null) return;

    final files = await _packageScanner.scan(path);

    setState(() {
      _updatedPackagePath = path;
      _updatedFiles = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Text('DocDiff', style: Theme.of(context).textTheme.headlineLarge),
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
                        fileCount: _originalFiles.length,
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
                        fileCount: _updatedFiles.length,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
