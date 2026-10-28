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
    final response = await dioClient.getApiResponse(
      ApiEndpoints.onboardStatus,
    );

    final body = response as Map<String, dynamic>;

    if (body['code'] != '0000') {
      throw Exception(
        body['message']?.toString() ??
            'Unable to retrieve onboarding status',
      );
    }

    return OnboardingStatusModel.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }
}