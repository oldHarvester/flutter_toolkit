// import 'dart:developer' as dev;

// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_toolkit/flutter_toolkit.dart';

// enum ThrottleLoggerType {
//   frame,
//   throttle,
//   debouncer,
// }

// class _ThrottleMessage with EquatableMixin {
//   const _ThrottleMessage({
//     required this.owner,
//     required this.message,
//   });

//   final String owner;
//   final String message;

//   @override
//   List<Object?> get props => [message, owner];
// }

// class ThrottleLogger {
//   ThrottleLogger({
//     required this.owner,
//     bool showLogs = true,
//     this.type = ThrottleLoggerType.throttle,
//     this.unique = true,
//     this.showDividers = true,
//     this.throttleDuration = const Duration(milliseconds: 300),
//   }) : _showLogs = showLogs;

//   final String owner;

//   final ThrottleLoggerType type;

//   final Duration throttleDuration;

//   late bool _showLogs;

//   final bool unique;

//   final bool showDividers;

//   final List<_ThrottleMessage> _messages = [];

//   FlexibleCompleter<void>? _frameCompleter;

//   void enableLogs() {
//     _showLogs = true;
//   }

//   void disableLogs() {
//     _showLogs = false;
//     _cancelFrame();
//   }

//   void _cancelFrame() {
//     _frameCompleter?.cancel();
//     _frameCompleter = null;
//     _messages.clear();
//   }

//   void _logMessage(_ThrottleMessage message) {
//     dev.log(message.message, name: message.owner);
//   }

//   void _logDivider() {
//     if (showDividers) {
//       dev.log('==========', name: owner);
//     }
//   }

//   void _onComplete() {
//     final messages = {..._messages}.toList();
//     _messages.clear();
//     final showDividers = messages.isNotEmpty && this.showDividers;
//     if (showDividers) {
//       _logDivider();
//     }
//     while (messages.isNotEmpty) {
//       final message = messages.removeAt(0);
//       _logMessage(message);
//     }
//     if (showDividers) {
//       _logDivider();
//     }
//   }

//   void log([Object? object, String? owner]) {
//     if (!_showLogs) return;
//     final message = object.toString();
//     final resultOwner = owner ?? this.owner;
//     final oldCompleter = _frameCompleter;
//     switch (type) {
//       case ThrottleLoggerType.frame:
//         if (oldCompleter == null || oldCompleter.isCompleted) {
//           final completer = FlexibleCompleter();
//           _frameCompleter = completer;
//           WidgetsBinding.instance.addPostFrameCallback(
//             (_) {
//               if (completer.canPerformAction(_frameCompleter)) {
//                 completer.complete();
//                 _onComplete();
//               }
//             },
//           );
//         }
//         break;
//       case ThrottleLoggerType.throttle:
//         _frameCompleter?.cancel();
//         final completer = FlexibleCompleter();
//         _frameCompleter = completer;
//         Future.delayed(
//           throttleDuration,
//           () {
//             if (completer.canPerformAction(_frameCompleter)) {
//               completer.complete();
//               _onComplete();
//             }
//           },
//         );
//         break;
//       case ThrottleLoggerType.debouncer:
//         if (oldCompleter == null || oldCompleter.isCompleted) {
//           final completer = FlexibleCompleter();
//           _frameCompleter = completer;
//           Future.delayed(
//             throttleDuration,
//             () {
//               if (completer.canPerformAction(_frameCompleter)) {
//                 completer.complete();
//                 _onComplete();
//               }
//             },
//           );
//         }
//     }
//     final throttleMessage = _ThrottleMessage(
//       owner: resultOwner,
//       message: message,
//     );
//     if (unique && _messages.contains(throttleMessage)) {
//       return;
//     }
//     _messages.add(throttleMessage);
//   }
// }

import 'dart:developer' as dev;

import 'package:equatable/equatable.dart';
import 'package:flutter_toolkit/utils/collections/throttle_collection.dart';

class _ThrottleMessage with EquatableMixin {
  const _ThrottleMessage({
    required this.owner,
    required this.message,
  });

  final String owner;
  final String message;

  @override
  List<Object?> get props => [message, owner];
}

class ThrottleLogger extends ThrottleCollection<_ThrottleMessage> {
  ThrottleLogger({
    super.enabled,
    super.equalityHandler,
    super.throttleDuration,
    super.type,
    super.unique = true,
    this.showDividers = true,
    String? owner,
  })  : owner = owner ?? 'ThrottleLogger',
        super(
          handler: (messages) {
            final showDiv = messages.isNotEmpty && showDividers;
            if (showDiv) {
              _logDivider(owner);
            }
            while (messages.isNotEmpty) {
              final message = messages.removeAt(0);
              _logMessage(message);
            }
            if (showDiv) {
              _logDivider(owner);
            }
          },
        );

  final String owner;
  final bool showDividers;

  static void _logMessage(_ThrottleMessage message) {
    dev.log(message.message, name: message.owner);
  }

  static void _logDivider(String? owner) {
    dev.log('==========', name: owner ?? 'ThrottleLogger');
  }

  void addLog([Object? object, String? owner]) {
    final resultOwner = owner ?? this.owner;
    add(
      _ThrottleMessage(
        owner: resultOwner,
        message: object.toString(),
      ),
    );
  }
}
