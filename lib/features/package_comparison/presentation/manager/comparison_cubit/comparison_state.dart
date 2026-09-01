import 'package:doc_diff/features/package_comparison/data/models/comparison_result.dart';

sealed class ComparisonState {}

final class ComparisonInitial extends ComparisonState {}

final class ComparisonLoading extends ComparisonState {}

final class ComparisonSuccess extends ComparisonState {
  final ComparisonResult result;

  ComparisonSuccess(this.result);
}

final class ComparisonFailure extends ComparisonState {
  final String message;

  ComparisonFailure(this.message);
}
