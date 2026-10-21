import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:star_drive/features/driver_verification/domain/entities/vechile_detail_response.dart';
import 'package:star_drive/features/driver_verification/domain/entities/vechile_detail_submission.dart';
import 'package:star_drive/features/driver_verification/domain/usecase/vechile_detail_usecase.dart';

part 'vechile_details_bloc_event.dart';
part 'vechile_details_bloc_state.dart';

class VehicleDetailsBloc
    extends Bloc<VechileDetailsBlocEvent, VechileDetailsBlocState> {
  final SubmitVehicleDetailsUseCase submitVehicleDetailsUseCase;

  VehicleDetailsBloc(this.submitVehicleDetailsUseCase, ) : super(const VechileDetailsBlocInitial()) {
    on<SubmitVechileDetails>(_onSubmitVechileDetails);
  }

  Future<void> _onSubmitVechileDetails(
    SubmitVechileDetails event,
    Emitter<VechileDetailsBlocState> emit,
  ) async {
    // Prevent duplicate submissions while the request is processing.
    if (state is VechileDetailsBlocLoading) return;

    emit(const VechileDetailsBlocLoading());

    try {
      final vehicleDetails = await submitVehicleDetailsUseCase(
        event.submission,
      );

      final isPending =
          vehicleDetails.vehicleStatus.toLowerCase() == 'pending';

      emit(
        VechileDetailsBlocSuccess(
          vehicleDetails: vehicleDetails,
          message: isPending
              ? 'Vehicle details submitted successfully. '
                  'Waiting for admin approval.'
              : 'Vehicle details submitted successfully.',
        ),
      );
    } on DioException catch (error) {
      final responseData = error.response?.data;

      final apiMessage = responseData is Map
          ? responseData['message']?.toString()
          : null;

      emit(
        VechileDetailsBlocFailure(
          apiMessage ??
              error.message ??
              'Network error. Please try again.',
        ),
      );
    } on FormatException catch (error) {
      emit(
        VechileDetailsBlocFailure(
          error.message.isNotEmpty
              ? error.message
              : 'Invalid server response.',
        ),
      );
    } catch (_) {
      emit(
        const VechileDetailsBlocFailure(
          'Unable to submit vehicle details. Please try again.',
        ),
      );
    }
  }
}