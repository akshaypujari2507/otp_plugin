import 'package:flutter/material.dart';
import 'package:otp_plugin/colors_theme.dart';

class OtpModel {
  bool isResend = false;
  bool isResendClicked = false;
  bool isSnackbarActive = false;
  bool isOtpSent = false;
  bool isOtpDisable = false;
  // bool isOtpExpired = false;
  bool isVerified = false;
  late FormFieldValidator<String> validator;
  // bool isLimitReached = false;
  // bool isIncorrect = false;
  bool isTimerVisible = false;
  // bool isLoading = false;
  String responseMsg = '';
  int otpLength = 6;
  Color textColor = ColorsTheme.textBlackColor;
  Color cursorColor = ColorsTheme.textBlackColor;
  BorderSide boxBorderColor =
      const BorderSide(color: ColorsTheme.textBlackColor);
  String timer = '';
  String otp = '';
  String expiryTimer = '';

  OtpModel();
}
