import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ten_second_challenge/main.dart'; // 修正: main.dartをインポート

void main() {
  group('TimerState Tests', () {
    test('startTimer starts the timer correctly', () async {
      final timerState = TimerState(); // 変更: main.dartからインポートしたTimerStateを使用

      // startTimerの呼び出し
      timerState.startTimer();

      // startTimerが呼ばれると、isRunningがtrueに変わることを確認
      expect(timerState.isRunning, true);

      // タイマーの更新が正常に行われていることを確認
      await Future.delayed(Duration(milliseconds: 100));
      expect(timerState.milliseconds, greaterThan(0));
    });

    test('stopTimer stops the timer correctly', () async {
      final timerState = TimerState();

      // タイマーを開始
      timerState.startTimer();

      // タイマーを停止
      timerState.stopTimer(10);

      // stopTimerが呼ばれると、isRunningがfalseに変わることを確認
      expect(timerState.isRunning, false);
    });

    test('resetTimer resets the timer correctly', () async {
      final timerState = TimerState();

      // タイマーを開始
      timerState.startTimer();

      // 100ms後にリセット
      await Future.delayed(Duration(milliseconds: 100));
      timerState.resetTimer();

      // リセット後、タイマーが初期状態に戻っていることを確認
      expect(timerState.isRunning, false);
      expect(timerState.milliseconds, 0);
    });
  });
}
