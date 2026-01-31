enum VerifyPurpose { reset,verify }

extension VerifyPurposeX on VerifyPurpose {
  String get value {
    switch (this) {
      case VerifyPurpose.reset:
        return 'RESET';
      case VerifyPurpose.verify:
        return 'VERIFY';
    }
  }
}
