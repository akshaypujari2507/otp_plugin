import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:otp_plugin/size_chart.dart';


/// blank space
const blankSpace = '\u200b';

class OtpForm extends StatefulWidget {
  FormFieldValidator<String> validator;
  bool isClearTextField;
  Color textColor;
  Color cursorColor;
  BorderSide boxBorderColor;
  int otpLength;
  bool isOtpDisable;
  List<TextEditingController> controllers;

  OtpForm(
      {super.key,
        required this.validator,
        required this.isClearTextField,
        required this.textColor,
        required this.cursorColor,
        required this.boxBorderColor,
        required this.otpLength,
        required this.isOtpDisable,
        required this.controllers,
      });

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  // String mergeOtp = '';
  // var otpValueEntered = '';

  //String? otpValue;
  // late int otpLength;
  bool isPaste = false;
  late String pasteString;
  late List<String> otpChar;
  final digitReg = RegExp(r'^[0-9]');

  @override
  void initState() {
    super.initState();
    otpChar = List.filled(widget.otpLength, '', growable: true);
  }

  // List<TextEditingController> controllers = <TextEditingController>[];

  @override
  void dispose() {
    // for (TextEditingController textEditingController in controllers) {
    //   textEditingController.dispose();
    widget.controllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = widget.textColor;
    BorderSide boxBorderColor = widget.boxBorderColor;
    SizeConfig().init(context);
    return Expanded(
        flex: 1,
        child: ListView.builder(
            physics:  const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: widget.otpLength,
            itemBuilder: (context, index) {
              widget.controllers.add(TextEditingController());
              if(isPaste) {
                widget.controllers[index].text = pasteString[index];
                if(index == widget.otpLength-1){
                  widget.validator(pasteString);
                  isPaste = false;
                  pasteString = '';
                  FocusScope.of(context).unfocus();
                }
              }
              return Container(
                margin: index == 0 ? const EdgeInsets.fromLTRB(7, 0, 10, 0)
                    : const EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: getProportionateScreenHeight(45),
                      //width: MediaQuery.of(context).size.width * 0.112,
                      width: getProportionateScreenWidth(MediaQuery.of(context).size.width * 0.10),
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: TextFormField(
                          enableInteractiveSelection: index == 0,
                          toolbarOptions: const ToolbarOptions(
                              copy: false,
                              cut: false,
                              paste: true,
                              selectAll: false
                          ),
                          cursorColor: widget.cursorColor,
                          controller: widget.controllers[index],
                          keyboardType: TextInputType.number,
                          readOnly: widget.isOtpDisable,
                          onFieldSubmitted: (value) {
                          },
                          onChanged: (value) {
                            if (index == 0 && value.length >= widget.otpLength) {
                              value = value.replaceFirst(blankSpace, '');
                              isPaste = true;

                              for (int i = 0; i < widget.otpLength; i++) {
                                if (!digitReg.hasMatch(value[i])) {
                                  isPaste = false;
                                  break;
                                }
                              }
                              if (isPaste) {
                                pasteString = value;
                                // controllers[index].text = '';
                                widget.controllers.clear();
                                setState(() {
                                  isPaste;
                                });
                              } else {
                                // controllers[index].clear();
                                widget.controllers[index].text = blankSpace;
                                widget.controllers[index].selection =
                                    TextSelection.fromPosition(
                                        TextPosition(offset: widget.controllers[index].text.length));
                              }
                              return;
                            }
                            if (value.isEmpty) {
                              if (index != 0) {
                                // otpChar[index-1] = '';
                                widget.controllers[index - 1].text = blankSpace;
                                FocusScope.of(context).previousFocus();
                              } else {
                                FocusScope.of(context).unfocus();
                              }
                              return;
                            }
                            if (value.characters.length > 1) {
                              if (value.contains(blankSpace)) {
                                value = value.replaceFirst(blankSpace, '');
                                // value = value.characters.last;
                                // controllers[index].text = value;
                              } else {
                                value = value.characters.last;
                                widget.controllers[index].text = value;
                              }
                            }
                            if (!digitReg.hasMatch(value)) {
                              // controllers[index].clear();
                              widget.controllers[index].text = blankSpace;
                              widget.controllers[index].selection =
                                  TextSelection.fromPosition(
                                      TextPosition(offset: value.length));
                              return;
                            }
                            // controllers[index].text = value;
                            // otpChar[index] = value;

                            if (index != widget.otpLength) {
                              if (widget.controllers[index + 1].text.isEmpty)
                                widget.controllers[index + 1].text = blankSpace;
                              FocusScope.of(context).nextFocus();
                            }

                            for (int i = 0; i < widget.otpLength; i++) {
                              otpChar[i] = widget.controllers[i].text;
                            }

                            var otpEntered =
                            otpChar.join('').replaceAll(blankSpace, '');
                            if (kDebugMode) {
                              print('otpEntered $otpEntered');
                            }
                            if (otpEntered.length == widget.otpLength) {
                              widget.validator(otpEntered);
                              FocusScope.of(context).unfocus();
                            }
                          },
                          // onEditingComplete: () => controllers.clear(),
                          showCursor: true,
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(fontSize: 14, color: textColor),
                          // maxLength: otpLength + 1,
                          maxLength: index == 0 ? widget.otpLength + 1 : 2,
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.symmetric(
                                vertical:
                                getProportionateScreenWidth(8)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  getProportionateScreenWidth(3)),
                              borderSide: boxBorderColor,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  getProportionateScreenWidth(3)),
                              borderSide: boxBorderColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }));
  }

}
