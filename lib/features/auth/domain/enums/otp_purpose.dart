enum OtpPurpose {
  register,
  forgotPassword,
  changePhone;

  String get apiValue {
    switch (this) {
      case OtpPurpose.register:
        return 'Registration';
      case OtpPurpose.forgotPassword:
        return 'ForgotPassword';
      case OtpPurpose.changePhone:
        return 'ChangePhone';  
    }
  }
}
