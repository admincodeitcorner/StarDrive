
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:star_drive/features/auth/domain/enums/otp_purpose.dart';
import 'package:star_drive/features/auth/domain/usecase/send_otp_usecase.dart';
import 'package:star_drive/features/dashboard/data/model/number_update_model.dart';
import 'package:star_drive/features/dashboard/domain/usecase/get_user_profile.dart';
import 'package:star_drive/features/dashboard/domain/usecase/update_phone_number.dart';
import 'package:star_drive/features/dashboard/domain/usecase/verify_change_phone_otp_usecase.dart';
import 'user_profile_event.dart' hide HistoryRequested;
import 'user_profile_state.dart' hide HistoryState, HistoryInitial, HistoryLoading, HistorySuccess, HistoryFailure;

class UserProfileBloc
    extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfile getUserProfile;
  final UpdatePhoneNumber updatePhoneNumber;
  final SendOtpUsecase sendOtpUsecase;
  // final VerifyChangePhoneOtpUseCase verifyChangePhoneOtpUseCase;

  UserProfileBloc({
    required this.getUserProfile,
    required this.updatePhoneNumber,
    required this.sendOtpUsecase,
    // required this.verifyChangePhoneOtpUseCase,
  }) : super(UserProfileInitial()) {
    on<UserProfileRequested>(_onUserProfileRequested);
    on<PhoneOtpSendRequested>(_onPhoneOtpSendRequested);
    on<PhoneNumberUpdateRequested>(_onPhoneNumberUpdateRequested);
  }

  // Fetch existing user profile
  Future<void> _onUserProfileRequested(
    UserProfileRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());

    try {
      final profile = await getUserProfile();
      emit(UserProfileLoaded(profile));
    } catch (e) {
      emit(
        UserProfileFailure(
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  // Send OTP to the new phone number
  Future<void> _onPhoneOtpSendRequested(
    PhoneOtpSendRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(PhoneOtpSending());

    try {
      final result = await sendOtpUsecase(
        contactNumber: event.contactNumber,
        purpose: OtpPurpose.changePhone,
      );

      result.fold(
        (failure) {
          emit(
            PhoneOtpSendFailure(
              failure.toString().replaceFirst('Exception: ', ''),
            ),
          );
        },
        (otpDetails) {
          emit(PhoneOtpSent());
        },
      );
    } catch (e) {
      emit(
        PhoneOtpSendFailure(
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  // Verify the ChangePhone OTP, then update the phone number
  Future<void> _onPhoneNumberUpdateRequested(
    PhoneNumberUpdateRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(PhoneNumberUpdating());

    try {
      // Step 1: Verify OTP with ChangePhone purpose
      

      // Step 2: Send the phone number and OTP to the update API
      final model = UpdatePhoneNumberModel(
        contactNumber: event.contactNumber,
        otpCode: event.otpCode,
      );

      await updatePhoneNumber(model);

      emit(PhoneNumberUpdateSuccess());

      // Refresh profile after a successful update
      add(const UserProfileRequested());
    } catch (e) {
      emit(
        PhoneNumberUpdateFailure(
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
   }
}
