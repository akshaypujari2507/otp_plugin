import 'package:flutter/material.dart';
import 'package:otp_plugin/colors_theme.dart';
import 'package:otp_plugin/common_widget.dart';
import 'package:otp_plugin/otp_form.dart';


class OtpModelView extends StatefulWidget {

  String resendOtpDurationInSec;
  String maskedMobileNum;
  String expirationTime;
  String otpMessage;
  int otpLength;
  VoidCallback reSendCallback;
  bool isOtpSent = false;
  bool fromValidate;
  bool isOtpDisable;
  bool isVerified;
  bool isClearTextField;
  FormFieldValidator<String> validator;
  List<TextEditingController> controllers;

  Color textColor;
  Color cursorColor;
  OtpModelView(
      {super.key,
      required this.resendOtpDurationInSec,
      required this.isOtpSent,
      required this.maskedMobileNum,
      required this.expirationTime,
      required this.otpMessage,
      required this.reSendCallback,
      required this.textColor,
      required this.cursorColor,
      required this.boxBorderColor,
      required this.validator,
      required this.isOtpDisable,
      required this.isClearTextField,
      required this.fromValidate,
      required this.controllers,
      this.otpLength = 6,
      this.isVerified = false
      });

  BorderSide boxBorderColor;
  @override
  State<OtpModelView> createState() => OtpModelViewState();
}

class OtpModelViewState extends State<OtpModelView> with TickerProviderStateMixin {
  int countDown = 0;
  int resendDuration = 0;
  bool isResend = false;
  bool isTimerVisible = true;

  @override
  void initState() {
    super.initState();
  }

 @override
  void dispose() {
    super.dispose();
  }

   Row buildTimer(int duration) {

    // if(resendDuration == 0) {
    //  resendDuration = duration - int.parse(widget.resendOtpDurationInSec);
     // }
    if (!widget.fromValidate) {
      resendDuration = duration - int.parse(widget.resendOtpDurationInSec);
    }
    print("duration = $duration | resendDuration = $resendDuration | countDown = $countDown | fromValidate = ${widget.fromValidate}");

     return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(" "),

      TweenAnimationBuilder(
            tween: Tween(begin: Duration(seconds: duration), end: Duration.zero),
            duration: Duration(seconds: duration),
            builder: (_, dynamic value, child) {
              countDown = value.inSeconds;
              if (value.inSeconds < 1) {
                Future.delayed(Duration.zero, () async {
                  setState(() {
                    widget.isOtpDisable = true;
                    isTimerVisible = false;
                  });
                });
              } else if (value.inSeconds == resendDuration){
                Future.delayed(Duration.zero, () async {
                  setState(() {
                    widget.isOtpDisable = false;
                    isResend = true;
                  });
                });

              }

              final minutes = value.inMinutes;
              final seconds = value.inSeconds % 60;

              String strMin = (minutes<10)? '0$minutes':'$minutes';
              String strSec = (seconds<10)? '0$seconds':'$seconds';

              String timerText = '$strMin:$strSec';

              return Text(
                timerText,
                style: const TextStyle(
                    color: Color(0xFFf37435),
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              );
            }
            )
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if(widget.isOtpDisable) {
      isTimerVisible = false;
    }
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: (!widget.isOtpSent)
            ? Column(
                children: [
                  getCloseButton(context),
                  Container(
                    padding: const EdgeInsets.only(top: 130),
                    child: Center(
                      child: Column(
                        children: const [
                          CircularProgressIndicator(
                            color: ColorsTheme.orangeColor,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text('Sending OTP...',
                            style: TextStyle(fontSize: 12, color: ColorsTheme.colorPrimary),
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      getCloseButton(context),
                      Container(
                          margin: const EdgeInsets.only(top: 12.0),
                          child: const Text(
                            "Verify OTP",
                            style: TextStyle(
                                color: ColorsTheme.purpleColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          )),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 0.0),
                          child: Text.rich(TextSpan(
                              text:
                                  'We have sent an OTP to your mobile number ',
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: ColorsTheme.textGrayColor),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: widget.maskedMobileNum,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )
                              ]))),
                      const SizedBox(
                        height: 18,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 0.0, bottom: 0),
                        child: Row(
                          children: [
                            (isTimerVisible)
                                ? const Text(
                                    "OTP expires in",
                                    style: TextStyle(
                                        color: ColorsTheme.textGrayColor,
                                        fontSize: 16),
                                  )
                                : const Text(
                                        "OTP has expired",
                                        style: TextStyle(
                                            color: ColorsTheme.imageRedColor,
                                            fontSize: 16),
                                      ),
                            if (isTimerVisible)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child:
                                buildTimer(
                                    (countDown == 0) ? int.parse(widget.expirationTime!) : countDown),

                              )
                          ],
                        ),
                      ),
                      OtpForm(
                          validator: widget.validator,
                          isClearTextField: widget.isClearTextField,
                          textColor: widget.textColor,
                          cursorColor: widget.cursorColor,
                          boxBorderColor: widget.boxBorderColor,
                          otpLength: widget.otpLength,
                          isOtpDisable: widget.isOtpDisable,
                      controllers: widget.controllers),

                      if (widget.isVerified)
                        Align(
                        alignment: Alignment.center,
                            child: Column(
                              children: const [
                                SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: CircularProgressIndicator(
                                    color: ColorsTheme.orangeColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Recharging. Please wait...',
                                  style: TextStyle(fontSize: 12, color: ColorsTheme.colorPrimary),
                                ),

                              ],
                            ),
                          ),
                          if(widget.otpMessage.isNotEmpty)
                            getOtpErrorMessage(
                                  context,
                          widget.otpMessage,
                          const TextStyle(fontSize: 14, color: Colors.red)),
                      const SizedBox(
                        height: 57,
                      ),
                      if(isTimerVisible)
                        Container(
                        margin: const EdgeInsets.only(top: 0.0),
                        child: Row(
                          children: [
                           const Text(
                              "Didn’t receive OTP?",
                              style: TextStyle(
                                  color: ColorsTheme.textGrayColor,
                                  fontSize: 16),
                            ),
                            TextButton(
                              style: ButtonStyle(

                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding:MaterialStateProperty.all(const EdgeInsets.fromLTRB(8,3,8,3)),
                                minimumSize: MaterialStateProperty.all(const Size(0, 0)),

                                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.hovered)) {
                                      return const Color(0x0fffa274);
                                    }
                                    if (states.contains(MaterialState.focused) ||
                                        states.contains(MaterialState.pressed)) {
                                      return const Color(0x0fffa274);
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              child: Text('Resend',
                                  style: TextStyle(
                                      fontFamily: 'Quicksand-SemiBold',
                                      color: (isResend)
                                          ? ColorsTheme.orangeColor
                                          : ColorsTheme
                                                  .textButtonLightGrayColor,
                                      fontSize: 16)),
                              onPressed: () {
                                if (!isResend) {
                                  return;
                                } else {
                                  widget.reSendCallback();
                                  Future.delayed(Duration.zero, () async {

                                    setState(() {
                                      isResend = false;
                                    });
                                  });
                                }
                              },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),


          ],
        ));
  }

}
