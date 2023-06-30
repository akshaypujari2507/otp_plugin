import 'package:flutter/material.dart';

Container getCloseButton(BuildContext context) {
  return Container(
    alignment: Alignment.topRight,
    margin: const EdgeInsets.only(top: 4, right: 0),
    constraints: BoxConstraints(maxHeight: 26),
    child: IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(maxWidth: 40),
      alignment: Alignment.topRight,
      icon: const Icon(Icons.close),
      color: Colors.black,
      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}

Wrap getOtpErrorMessage(
    BuildContext context, String errorText, TextStyle errorTextStyle) {
  return Wrap(children: [
    SizedBox(
      // height: 30,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 2, right: 6),
            child: const Icon(
              Icons.warning,
              color: Colors.red,
              size: 14,
            ),
          ),

          // const SizedBox(width: 5,),
          Expanded(
            child: Text(
              errorText,
              // 'Invalid OTP, Enter the correct one',
              style: errorTextStyle,
            ),
          )
        ],
      ),
    ),
  ]);
}

