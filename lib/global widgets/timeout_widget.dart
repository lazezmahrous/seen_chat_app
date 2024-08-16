import 'dart:async';

import 'package:flutter/material.dart';

class TimeoutWidget extends StatefulWidget {
  const TimeoutWidget({super.key});
  @override
  State<TimeoutWidget> createState() => _TimeoutWidgetState();
}

class _TimeoutWidgetState extends State<TimeoutWidget> {
  late Timer _timer;
  int _start = 120;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void resetTimer() {
    _timer.cancel();
    setState(() {
      _start = 120;
    });
    startTimer();
  }

  String get timerText {
    final minutes = (_start ~/ 60).toString().padLeft(2, '0');
    final seconds = (_start % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _start == 0
            ? TextButton(
                onPressed: resetTimer,
                child: const Text('إعادة طلب'),
              )
            : Text(
                timerText,
                style: const TextStyle(fontSize: 15),
              ), // Hide the button when the timer is running
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('الكود لم يصل بعد'),
        ),
      ],
    );
  }
}
