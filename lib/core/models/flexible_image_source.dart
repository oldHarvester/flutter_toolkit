import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';

sealed class FlexibleImageSource with EquatableMixin {
  const FlexibleImageSource();

  bool get isSvg => fileFormat == FileFormat.svg;

  bool get supported => this is! FlexibleUnsupportedImageSource;

  factory FlexibleImageSource.fromSource(String source) {
    final base64Bytes = source.tryBase64Decode;

    FlexibleUnsupportedImageSource? checkSupport(FileFormat fileFormat) {
      if (!fileFormat.isImage) {
        return FlexibleUnsupportedImageSource(
          fileFormat: fileFormat,
          source: source,
        );
      }
      return null;
    }

    if (base64Bytes != null) {
      final fileFormat = base64Bytes.fileFormat;
      return checkSupport(fileFormat) ??
          FlexibleBase64ImageSource(
            base64: source,
            bytes: base64Bytes,
          );
    } else if (source.isWebUrl) {
      final fileFormat = FileFormat.fromFilename(source);
      return checkSupport(fileFormat) ??
          FlexibleNetworkImageSource(
            url: source,
          );
    } else {
      final fileFormat = FileFormat.fromFilename(source);
      return checkSupport(fileFormat) ??
          FlexibleAssetImageSource(
            source: source,
          );
    }
  }

  FileFormat get fileFormat {
    final source = this;
    return switch (source) {
      FlexibleUnsupportedImageSource _ => source._fileFormat,
      FlexibleAssetImageSource _ => FileFormat.fromFilename(source.source),
      FlexibleNetworkImageSource _ => FileFormat.fromFilename(source.url),
      FlexibleMemoryImageSource _ => FileFormat.fromBytes(source.bytes),
    };
  }
}

class FlexibleUnsupportedImageSource extends FlexibleImageSource {
  const FlexibleUnsupportedImageSource({
    required this.source,
    required FileFormat fileFormat,
  }) : _fileFormat = fileFormat;

  final String source;
  final FileFormat _fileFormat;

  @override
  List<Object?> get props => [source, _fileFormat];
}

class FlexibleAssetImageSource extends FlexibleImageSource {
  const FlexibleAssetImageSource({
    required this.source,
  });

  final String source;

  @override
  List<Object?> get props => [source];
}

class FlexibleNetworkImageSource extends FlexibleImageSource {
  const FlexibleNetworkImageSource({
    required this.url,
  });

  final String url;

  @override
  List<Object?> get props => [url];
}

class FlexibleMemoryImageSource extends FlexibleImageSource {
  const FlexibleMemoryImageSource({
    required this.bytes,
  });

  final Uint8List bytes;

  @override
  List<Object?> get props => [
        const DeepCollectionEquality().hash(bytes),
      ];
}

class FlexibleBase64ImageSource extends FlexibleMemoryImageSource {
  const FlexibleBase64ImageSource({
    required this.base64,
    required super.bytes,
  });

  final String base64;

  @override
  List<Object?> get props => [
        ...super.props,
        base64,
      ];
}
