import 'package:doc_diff/core/services/pdf_render_service.dart';
import 'package:doc_diff/features/package_comparison/data/services/pdf_diff_service.dart';
import 'package:doc_diff/features/package_comparison/presentation/manager/pdf_diff_cubit/pdf_diff_cubit.dart';
import 'package:doc_diff/features/package_comparison/presentation/manager/pdf_diff_cubit/pdf_diff_state.dart';
import 'package:doc_diff/features/package_comparison/presentation/widgets/pdf_page_comparison.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PdfDiffView extends StatelessWidget {
  const PdfDiffView({
    super.key,
    required this.originalPdfPath,
    required this.updatedPdfPath,
  });

  final String originalPdfPath;
  final String updatedPdfPath;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PdfDiffCubit(PdfDiffService(PdfRenderService()))
        ..comparePdfs(
          originalPdfPath: originalPdfPath,
          updatedPdfPath: updatedPdfPath,
        ),
      child: Scaffold(
        appBar: AppBar(title: const Text('PDF Comparison')),
        body: BlocBuilder<PdfDiffCubit, PdfDiffState>(
          builder: (context, state) {
            return switch (state) {
              PdfDiffInitial() => const SizedBox.shrink(),

              PdfDiffLoading() => const Center(
                child: CircularProgressIndicator(),
              ),

              PdfDiffSuccess(:final result) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: result.pages.length,
                itemBuilder: (context, index) {
                  final page = result.pages[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Page ${page.pageNumber}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Spacer(),
                              Text(page.statusLabel),
                            ],
                          ),
                          const SizedBox(height: 12),
                          PdfPageComparison(
                            originalPage: page.originalPage,
                            updatedPage: page.updatedPage,
                            diffPage: page.diffPage, status: page.status,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              PdfDiffFailure(:final message) => Center(child: Text(message)),
            };
          },
        ),
      ),
    );
  }
}
