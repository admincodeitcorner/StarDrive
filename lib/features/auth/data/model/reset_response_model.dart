class ResetPasswordResponseModel {
  final String code;
  final String message;

  const ResetPasswordResponseModel({
    required this.code,
    required this.message,
  });

  factory ResetPasswordResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ResetPasswordResponseModel(
      code: json['code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
}