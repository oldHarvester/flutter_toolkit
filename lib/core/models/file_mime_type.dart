import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

sealed class FileMimeType with EquatableMixin {
  const FileMimeType(this.name);

  const factory FileMimeType.unknown(String name) = UnknownFileMimeType;

  static FileMimeType? fromStringOrNull(String name) {
    return values.firstWhereOrNull(
      (element) {
        return element.name == name;
      },
    );
  }

  factory FileMimeType.fromString(String name) {
    return fromStringOrNull(name) ?? FileMimeType.unknown(name);
  }

  static const FileMimeType emptyUnknown = UnknownFileMimeType('');
  static const FileMimeType pdf = PdfFileMimeType();
  static const FileMimeType xlsx = XlsxFileMimeType();
  static const FileMimeType xls = XlsFileMimeType();
  static const FileMimeType jpeg = JpegFileMimeType();
  static const FileMimeType png = PngFileMimeType();
  static const FileMimeType webp = WebpFileMimeType();
  static const FileMimeType svg = SvgFileMimeType();
  static const FileMimeType bmp = BmpFileMimeType();
  static const FileMimeType gif = GifFileMimeType();
  static const FileMimeType doc = DocFileMimeType();
  static const FileMimeType docx = DocxFileMimeType();

  static const List<FileMimeType> values = [
    pdf,
    xls,
    xlsx,
    jpeg,
    png,
    webp,
    svg,
    bmp,
    gif,
    doc,
    docx,
  ];

  final String name;

  @override
  List<Object?> get props => [name];
}

final class PdfFileMimeType extends FileMimeType {
  const PdfFileMimeType() : super('application/pdf');
}

final class XlsxFileMimeType extends FileMimeType {
  const XlsxFileMimeType()
      : super(
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
}

final class XlsFileMimeType extends FileMimeType {
  const XlsFileMimeType() : super('application/vnd.ms-excel');
}

final class JpegFileMimeType extends FileMimeType {
  const JpegFileMimeType() : super('image/jpeg');
}

final class PngFileMimeType extends FileMimeType {
  const PngFileMimeType() : super('image/png');
}

final class WebpFileMimeType extends FileMimeType {
  const WebpFileMimeType() : super('image/webp');
}

final class SvgFileMimeType extends FileMimeType {
  const SvgFileMimeType() : super('image/svg+xml');
}

final class BmpFileMimeType extends FileMimeType {
  const BmpFileMimeType() : super('image/bmp');
}

final class GifFileMimeType extends FileMimeType {
  const GifFileMimeType() : super('image/gif');
}

final class DocFileMimeType extends FileMimeType {
  const DocFileMimeType() : super('application/msword');
}

final class DocxFileMimeType extends FileMimeType {
  const DocxFileMimeType()
      : super(
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document');
}

final class UnknownFileMimeType extends FileMimeType {
  const UnknownFileMimeType(super.name);
}
