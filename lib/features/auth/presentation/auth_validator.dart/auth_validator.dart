class AuthValidator {
  AuthValidator._();

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    final name = value.trim();

    if (name.length < 3) {
      return 'Name must contain at least 3 characters';
    }
    final nameRegex = RegExp(r"^[a-zA-Z\u0600-\u06FF\s'-]+$");

    if (!nameRegex.hasMatch(name)) {
      return 'Name can only contain letters and spaces';
    }

    // Prevent names containing only spaces or symbols
    if (!RegExp(r'[a-zA-Z\u0600-\u06FF]').hasMatch(name)) {
      return 'Please enter a valid name';
    }
    return null;
  }

  // static String? validateFatherName(String? value) {
  //   if (value == null || value.trim().isEmpty) {
  //     return 'Father name is required';
  //   }

  //   if (value.trim().length < 3) {
  //     return 'Father name must contain at least 3 characters';
  //   }

  //   return null;
  // }

  static String? validateCnic(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CNIC is required';
    }

    // Pakistani CNIC format: 12345-1234567-1
    final cnicRegex = RegExp(r'^\d{5}-\d{7}-\d{1}$');

    if (!cnicRegex.hasMatch(value.trim())) {
      return 'Enter CNIC in 12345-1234567-1 format';
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Contact number is required';
    }

    // Pakistan mobile number: 03XXXXXXXXX
    final phoneRegex = RegExp(r'^03\d{9}$');

    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Enter a valid number, e.g. 03001234567';
    }

    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }

    if (value.trim().length < 5) {
      return 'Address must contain at least 5 characters';
    }

    return null;
  }

  static String? validateDob(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select date of birth';
    }

    final dob = DateTime.tryParse(value.trim());

    if (dob == null) {
      return 'Please select a valid date';
    }

    if (dob.isAfter(DateTime.now())) {
      return 'Date of birth cannot be in the future';
    }

    final today = DateTime.now();
    var age = today.year - dob.year;

    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }

    if (age < 18) {
      return 'You must be at least 18 years old';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain an uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain a lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain a number';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }
}
