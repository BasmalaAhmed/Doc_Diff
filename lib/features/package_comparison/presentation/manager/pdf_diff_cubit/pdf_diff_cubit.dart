import 'package:doc_diff/core/utils/app_logger.dart';
import 'package:doc_diff/features/package_comparison/data/services/pdf_diff_service.dart';
import 'package:doc_diff/features/package_comparison/presentation/manager/pdf_diff_cubit/pdf_diff_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PdfDiffCubit extends Cubit<PdfDiffState> {
  PdfDiffCubit(this._pdfDiffService) : super(PdfDiffInitial());

  final PdfDiffService _pdfDiffService;

  Future<void> comparePdfs({
    required String originalPdfPath,
    required String updatedPdfPath,
  }) async {
    emit(PdfDiffLoading());

    appLogger.i('Starting PDF comparison');

    try {
      final result = await _pdfDiffService.compare(
        originalPdfPath: originalPdfPath,
        updatedPdfPath: updatedPdfPath,
      );

      emit(PdfDiffSuccess(result));
    } catch (e, stackTrace) {
      appLogger.e('Failed to compare PDFs', error: e, stackTrace: stackTrace);
      emit(
        PdfDiffFailure('Something went wrong while comparing the PDF files.'),
      );
    }
  }
}
