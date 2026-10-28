import 'package:star_drive/core/constant/apis_endpoints.dart';
import 'package:star_drive/core/network/dio_client.dart';
import '../models/on_board_status_model.dart' show OnboardingStatusModel;


abstract interface class OnboardingRemoteDataSource {
  Future<OnboardingStatusModel> getOnboardingStatus();
}

class OnboardingRemoteDataSourceImpl
    implements OnboardingRemoteDataSource {
  final DioClient dioClient;

  OnboardingRemoteDataSourceImpl({
    required this.dioClient,
  });

   @override
  Future<OnboardingStatusModel> getOnboardingStatus() async {
    final result = await dioClient.getApiResponse(
      ApiEndpoints.onboardStatus,
    );

    return result.fold(
      (exception) {
        throw exception;
      },
      (response) {
        final body = response.data;

        if (body is! Map<String, dynamic>) {
          throw Exception(
            'Invalid onboarding API response format',
          );
        }

        if (body['code']?.toString() != '0000') {
          throw Exception(
            body['message']?.toString() ??
                'Unable to retrieve onboarding status',
          );
        }

        final data = body['data'];

        if (data is! Map<String, dynamic>) {
          throw Exception(
            'Invalid onboarding status data',
          );
        }

        return OnboardingStatusModel.fromJson(data);
      },
    );
  }
}