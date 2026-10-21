enum OtpPurpose {
  register,
  forgotPassword;

  String get apiValue {
    switch (this) {
      case OtpPurpose.register:
        return 'Registration';
      case OtpPurpose.forgotPassword:
        return 'ForgotPassword';
    }
  }
}
