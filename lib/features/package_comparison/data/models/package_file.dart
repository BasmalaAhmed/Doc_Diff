class PackageFile {
  final String name;
  final String path;
  final String relativePath;
  final int size;

  const PackageFile({
    required this.name,
    required this.path,
    required this.relativePath,
    required this.size,
  });
}
