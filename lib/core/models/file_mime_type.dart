import 'package:equatable/equatable.dart';

class FileMimeType with EquatableMixin {
  const FileMimeType._(this.name);

  const FileMimeType.unknown(this.name);

  const FileMimeType.fromString(this.name);

  final String name;

  static const FileMimeType empty = FileMimeType._(
    '',
  );

  static const FileMimeType pdf = FileMimeType._(
    'application/pdf',
  );

  static const FileMimeType xlsx = FileMimeType._(
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  );

  static const FileMimeType xls = FileMimeType._(
    'application/vnd.ms-excel',
  );

  static const FileMimeType jpeg = FileMimeType._(
    'image/jpeg',
  );

  static const FileMimeType png = FileMimeType._(
    'image/png',
  );

  static const FileMimeType webp = FileMimeType._(
    'image/webp',
  );

  static const FileMimeType svg = FileMimeType._(
    'image/svg+xml',
  );

  static const FileMimeType bmp = FileMimeType._(
    'image/bmp',
  );

  static const FileMimeType gif = FileMimeType._(
    'image/gif',
  );

  static const FileMimeType doc = FileMimeType._(
    'application/msword',
  );

  static const FileMimeType docx = FileMimeType._(
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  );

  @override
  List<Object?> get props => [name];
}
