import 'package:dartz/dartz.dart';
import 'package:star_drive/core/error/failure.dart';
import 'package:star_drive/features/driver_verification/domain/entities/driver_document.dart';
import 'package:star_drive/features/driver_verification/domain/entities/driver_documents_submitted_detail_response.dart';
import 'package:star_drive/features/driver_verification/domain/repositories/driver_documents_repositories.dart';

// ADAPT: if you have a base UseCase<Type, Params>, extend it instead.
class SendDocumentUseCase {
  final DriverDocumentsRepository _repository;

  const SendDocumentUseCase(this._repository);

  Future<Either<Failure, DriverDocumentsSubmittedDetailResponse>> call(DriverDocuments documents) {
    return _repository.sendDocument(documents);
  }
}