import 'package:dartz/dartz.dart';
import 'package:star_drive/core/error/failure.dart';

import 'package:star_drive/features/driver_verification/domain/entities/driver_document.dart';
import 'package:star_drive/features/driver_verification/domain/entities/driver_documents_submitted_detail_response.dart';


abstract class DriverDocumentsRepository {
  
  Future<Either<Failure, DriverDocumentsSubmittedDetailResponse>> sendDocument(DriverDocuments documents);
}