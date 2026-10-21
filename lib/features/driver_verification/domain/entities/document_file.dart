import 'package:equatable/equatable.dart';

class DocumentFile extends Equatable {
  final String path;
  final String? fileName;

  const DocumentFile({required this.path, this.fileName});

  @override
  List<Object?> get props => [path, fileName];
}