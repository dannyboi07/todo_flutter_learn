import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final Widget? content;
  final String secondaryButtonText;
  final void Function()? onSecondaryButtonPress;
  final String primaryButtonText;
  final void Function()? onPrimaryButtonPress;

  const CustomAlertDialog(
      {super.key,
      required this.title,
      this.content,
      this.secondaryButtonText = "Cancel",
      this.onSecondaryButtonPress,
      this.primaryButtonText = "Submit",
      this.onPrimaryButtonPress});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: <Widget>[
        OutlinedButton(
          onPressed: () {
            if (onSecondaryButtonPress != null) {
              onSecondaryButtonPress!();
            }
            Navigator.of(context).pop();
          },
          style: OutlinedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: Text(secondaryButtonText),
        ),
        ElevatedButton(
          onPressed: () {
            if (onPrimaryButtonPress != null) {
              onPrimaryButtonPress!();
            }
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6))),
          child: Text(primaryButtonText),
        )
      ],
    );
  }
}
