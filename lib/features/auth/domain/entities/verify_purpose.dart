enum VerifyPurpose { reset }

extension VerifyPurposeX on VerifyPurpose {
  String get value {
    switch (this) {
      case VerifyPurpose.reset:
        return 'RESET';
    }
  }
}
