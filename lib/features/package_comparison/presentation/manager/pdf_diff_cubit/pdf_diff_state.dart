import 'package:doc_diff/features/package_comparison/data/models/pdf_diff_result.dart';

sealed class PdfDiffState {}

final class PdfDiffInitial extends PdfDiffState {}

final class PdfDiffLoading extends PdfDiffState {}

final class PdfDiffSuccess extends PdfDiffState {
  final PdfDiffResult result;

  PdfDiffSuccess(this.result);
}

final class PdfDiffFailure extends PdfDiffState {
  final String message;

  PdfDiffFailure(this.message);
}
