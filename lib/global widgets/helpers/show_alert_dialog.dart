import 'package:flutter/material.dart';

Future<void> showAlertDialog({
  required BuildContext context,
  required String title,
  required String body,
  required String actionsTextButtonTow,
  required String actionsTextButtonOne,
  Function()? actionsButtonTow,
  required Icon icon,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        // <-- SEE HERE
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              icon,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                    child: Text(
                  body,
                  textAlign: TextAlign.center,
                )),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(actionsTextButtonOne),
          ),
          TextButton(
            onPressed: actionsButtonTow,
            child: Text(actionsTextButtonTow),
          ),
        ],
      );
    },
  );
}
