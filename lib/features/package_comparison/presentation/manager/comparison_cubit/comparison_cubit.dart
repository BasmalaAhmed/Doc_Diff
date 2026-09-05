import 'package:doc_diff/features/package_comparison/data/services/comparison_service.dart';
import 'package:doc_diff/features/package_comparison/data/services/package_scanner.dart';
import 'package:doc_diff/features/package_comparison/presentation/manager/comparison_cubit/comparison_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComparisonCubit extends Cubit<ComparisonState> {
  ComparisonCubit(this._packageScanner, this._comparisonService, )
    : super(ComparisonInitial());

  final ComparisonService _comparisonService;
  final PackageScanner _packageScanner;

  Future<void> comparePackages({
    required String originalPackagePath,
    required String updatedPackagePath,
  }) async {
    emit(ComparisonLoading());

    try {
      final originalFiles = await _packageScanner.scan(originalPackagePath);

      final updatedFiles = await _packageScanner.scan(updatedPackagePath);

      final result = await _comparisonService.compare(
        originalFiles: originalFiles,
        updatedFiles: updatedFiles,
      );

      emit(ComparisonSuccess(result));


    } catch (e) {

      emit(
        ComparisonFailure('Something went wrong while comparing the packages.'),
      );

    }
  }

}
