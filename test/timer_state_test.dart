import 'package:flutter_test/flutter_test.dart';
import 'package:ten_second_challenge/main.dart'; // 正しいプロジェクト名を使用
import 'package:provider/provider.dart';

void main() {
  group('TimerState Tests', () {
    test('Initial state is correct', () {
      final timerState = TimerState();
      expect(timerState.milliseconds, equals(0));
      expect(timerState.isRunning, isFalse);
    });

    test('Timer increments correctly', () async {
      final timerState = TimerState();
      timerState.startTimer();

      await Future.delayed(Duration(milliseconds: 50));
      expect(timerState.milliseconds, greaterThan(0));
      timerState.stopTimer(10);
    });
  });
}
