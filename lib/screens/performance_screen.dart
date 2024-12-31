import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/timer_state.dart';
import '../widgets/performance_summary.dart';
import 'home_screen.dart';

class PerformanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerState = context.watch<TimerState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('成績'),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showConfirmationDialog(context, timerState);
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: PerformanceSummary(
                totalPlays: timerState.totalPlays,
                totalPerfect: timerState.totalPerfect,
                totalSuccess: timerState.totalSuccess,
                totalFails: timerState.totalFails,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text(
                  'タイトルに戻る',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, TimerState timerState) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('確認'),
          content: const Text('成績をリセットしますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('いいえ'),
            ),
            TextButton(
              onPressed: () {
                timerState.clearLogs();
                Navigator.pop(context);
              },
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
  }
}
