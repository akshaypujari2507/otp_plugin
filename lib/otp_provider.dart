
import 'package:flutter/material.dart';
import 'package:otp_plugin/otp_model.dart';

class OtpProvider extends ChangeNotifier {
  OtpModel otpModel = OtpModel();


  void updateOtpModal(
      {
      //required OtpSent? otpSent,
      required bool isResend,
      required bool isTimerVisible,
      required bool isSnackbarActive,
      required bool isResendClicked,
      // bool? isIncorrect,
      required bool isVerified,
      required String timer,
      // required String expiryTimer,
      required String responseMsg}) {
    otpModel.timer = timer;
    //otpModel.otpSent = otpSent;
    otpModel.isResend = isResend;
    otpModel.isResendClicked = isResendClicked;
    // if(isIncorrect != null) {
    //   otpModel.isIncorrect = isIncorrect;
    // }
    otpModel.isVerified = isVerified;
    otpModel.isTimerVisible = isTimerVisible;
    // otpModel.expiryTimer = expiryTimer;

    otpModel.isSnackbarActive = isSnackbarActive;
    otpModel.responseMsg = responseMsg;
    //TransactionModel(transactionID: transactionID,fastagSelected: fastagSel,amount: amount);
    notifyListeners();
  }



  clearInstances() {
    otpModel =
        OtpModel();
  }
}
