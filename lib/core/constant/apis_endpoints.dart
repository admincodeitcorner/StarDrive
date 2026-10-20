class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://testingenv2.ngrok.app/api/';

  static const String register = 'auth/register';
  static const String login = 'auth/login';
  static const String sendOtp = 'otp/send';
  static const verifyOtp = 'otp/verify';
  static const resetPassword = 'auth/reset-password';
  static const driverDoc = '/driver/documents';

}
