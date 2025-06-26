import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        RawGestureDetector,
        GestureRecognizerFactory,
        GestureRecognizerFactoryWithHandlers;
import 'package:flutter/gestures.dart'
    show
        OneSequenceGestureRecognizer,
        PointerDownEvent,
        GestureDisposition,
        PointerEvent;

class SinglePointerRecognizer extends OneSequenceGestureRecognizer {
  int _p = 0;

  @override
  void addPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer);

    if (_p == 0) {
      resolve(GestureDisposition.rejected);
      _p = event.pointer;
    } else {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  String get debugDescription => 'only one pointer recognizer';

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {
    if (!event.down && event.pointer == _p) {
      _p = 0;
    }
  }
}

class SinglePointerRecognizerWrapper extends StatelessWidget {
  const SinglePointerRecognizerWrapper({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        SinglePointerRecognizer:
            GestureRecognizerFactoryWithHandlers<SinglePointerRecognizer>(
          () => SinglePointerRecognizer(),
          (SinglePointerRecognizer instance) {},
        )
      },
      child: child,
    );
  }
}
