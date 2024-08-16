import 'package:flutter/material.dart';
import 'package:seen/global%20widgets/loading_widgets/chat_loading_widget.dart';

class ShowLoading extends StatefulWidget {
  const ShowLoading({super.key});
  @override
  State<ShowLoading> createState() => _ShowLoadingState();
}

class _ShowLoadingState extends State<ShowLoading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShowLoading'),
      ),
      body: const Column(
        children: [
          ChatLoadingWidget(),
        ],
      ),
    );
  }
}
