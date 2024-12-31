import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onStartStop;
  final VoidCallback onReset;
  final bool isRunning;

  ActionButtons({
    required this.onStartStop,
    required this.onReset,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onReset,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // 修正点: primary -> backgroundColor
          ),
          child: Text('リセット'),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          onPressed: onStartStop,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // 修正点: primary -> backgroundColor
          ),
          child: Text(isRunning ? 'ストップ' : 'スタート'),
        ),
      ],
    );
  }
}
