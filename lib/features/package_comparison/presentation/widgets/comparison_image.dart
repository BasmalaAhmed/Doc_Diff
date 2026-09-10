import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ComparisonImage extends StatefulWidget {
  const ComparisonImage({super.key, required this.title, required this.image});

  final String title;
  final Uint8List? image;

  @override
  State<ComparisonImage> createState() => _ComparisonImageState();
}

class _ComparisonImageState extends State<ComparisonImage> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: widget.image == null
              ? const SizedBox(
                  height: 200,
                  child: Center(child: Text('Not Available')),
                )
              : SizedBox(
                  height: 400,
                  child: Listener(
                    onPointerSignal: (event) {
                      if (event is PointerScrollEvent) {
                        GestureBinding.instance.pointerSignalResolver.register(
                          event,
                          (PointerSignalEvent event) {
                            final scrollEvent = event as PointerScrollEvent;
                            final currentMatrix =
                                _transformationController.value;
                            final currentScale = currentMatrix
                                .getMaxScaleOnAxis();
                            final newScale = scrollEvent.scrollDelta.dy < 0
                                ? currentScale * 1.1
                                : currentScale / 1.1;
                            final clampedScale = newScale.clamp(1.0, 5.0);

                            if (clampedScale == currentScale) return;

                            final effectiveScaleFactor =
                                clampedScale / currentScale;

                            final Offset focalPoint = scrollEvent.localPosition;
                            final Matrix4 invertedMatrix = Matrix4.inverted(
                              currentMatrix,
                            );
                            final Offset sceneFocalPoint =
                                MatrixUtils.transformPoint(
                                  invertedMatrix,
                                  focalPoint,
                                );

                            final Matrix4 newMatrix = currentMatrix.clone()
                              ..translate(
                                sceneFocalPoint.dx,
                                sceneFocalPoint.dy,
                              )
                              ..scale(effectiveScaleFactor)
                              ..translate(
                                -sceneFocalPoint.dx,
                                -sceneFocalPoint.dy,
                              );
print('current scale: $currentScale, new scale: $clampedScale');

                            _transformationController.value = newMatrix;
                          },
                        );
                      }
                    },
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      minScale: 1.0,
                      maxScale: 5.0,
                      panEnabled: true,
                      scaleEnabled: true,
                      panAxis: PanAxis.free,
                      child: Image.memory(widget.image!, fit: BoxFit.contain),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
