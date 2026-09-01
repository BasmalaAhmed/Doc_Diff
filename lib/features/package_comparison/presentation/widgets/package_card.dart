import 'package:flutter/material.dart';

class PackageCard extends StatelessWidget {
  const PackageCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.selectedPath,
    required this.onSelect,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String? selectedPath;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 64),
                const SizedBox(height: 20),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  selectedPath ?? subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: onSelect,
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Select Folder'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
