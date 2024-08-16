import 'package:flutter/material.dart';
import 'package:screenshot_callback/screenshot_callback.dart';

class ScreenshotListenerScreen extends StatefulWidget {
  const ScreenshotListenerScreen({super.key});

  @override
  _ScreenshotListenerScreenState createState() =>
      _ScreenshotListenerScreenState();
}

class _ScreenshotListenerScreenState extends State<ScreenshotListenerScreen> {
  ScreenshotCallback screenshotCallback = ScreenshotCallback();
  String message = "لم يتم أخذ لقطة شاشة بعد";

  @override
  void initState() {
    super.initState();
    screenshotCallback.addListener(() {
      setState(() {
        message = "تم أخذ لقطة شاشة!";
      });
    });
  }

  @override
  void dispose() {
    screenshotCallback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("التحقق من لقطة الشاشة"),
      ),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
