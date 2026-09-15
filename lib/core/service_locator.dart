import 'package:doc_diff/core/services/hash_service.dart';
import 'package:doc_diff/core/services/image_decoder_service.dart';
import 'package:doc_diff/core/services/pdf_render_service.dart';
import 'package:doc_diff/features/package_comparison/data/services/comparison_service.dart';
import 'package:doc_diff/features/package_comparison/data/services/package_scanner.dart';
import 'package:doc_diff/features/package_comparison/data/services/pdf_diff_service.dart';
import 'package:doc_diff/features/package_comparison/data/services/pdf_page_matcher.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator() {
  //Core Services
  sl.registerLazySingleton(() => HashService());
  sl.registerLazySingleton(() => ImageDecoderService());
  sl.registerLazySingleton(() => PdfRenderService());
  //Feature Services
  sl.registerLazySingleton(() => PackageScanner());
  sl.registerLazySingleton(() => ComparisonService(sl()));
  sl.registerLazySingleton(() => PdfPageMatcher(sl()));
  sl.registerLazySingleton(() => PdfDiffService(sl(), sl(), sl()));
}
