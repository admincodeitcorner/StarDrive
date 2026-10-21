import 'package:dartz/dartz.dart';
import 'package:star_drive/core/error/failure.dart';
import 'package:star_drive/core/network/error_mapper.dart';
import 'package:star_drive/features/driver_verification/data/datasource/driver_documents_remote_datasource.dart';
import 'package:star_drive/features/driver_verification/data/models/driver_documents_request_model.dart';
import 'package:star_drive/features/driver_verification/domain/entities/driver_document.dart';

import 'package:star_drive/features/driver_verification/domain/entities/driver_documents_submitted_detail_response.dart';
import 'package:star_drive/features/driver_verification/domain/repositories/driver_documents_repositories.dart';

class DriverDocumentsRepositoryImpl implements DriverDocumentsRepository {
  final DriverDocumentsRemoteDataSource _remote;

  const DriverDocumentsRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, DriverDocumentsSubmittedDetailResponse>> sendDocument(
    DriverDocuments documents,
  ) async {
    final result = await _remote.sendDocument(
      DriverDocumentsRequestModel.fromEntity(documents),
    );

    return result.fold<Either<Failure, DriverDocumentsSubmittedDetailResponse>>(
      (exception) => Left(ErrorMapper.map(exception)),
      (apiResponse) {
        final data = apiResponse.data;
        if (data == null) {
          return const Left(
            UnexpectedFailure('Server returned no document details.'),
          );
        }
        return Right(data); // Model extends the entity
      },
    );
  }
}