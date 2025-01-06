import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ten_second_challenge/widgets/action_buttons.dart';

void main() {
  testWidgets('ActionButtons widget test', (WidgetTester tester) async {
    bool isRunning = false;
    bool resetPressed = false;
    bool startStopPressed = false;
    String timerText = '00.00';

    // テスト用のウィジェットを作成
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Text(timerText, key: Key('timerText')),
              ActionButtons(
                onStartStop: () {
                  startStopPressed = true;
                  isRunning = !isRunning;
                },
                onReset: () {
                  resetPressed = true;
                  timerText = '00.00';
                  isRunning = false; // タイマーを停止
                },
                isRunning: isRunning,
              ),
            ],
          ),
        ),
      ),
    );

    // 初期状態を確認
    expect(find.text('リセット'), findsOneWidget);
    expect(find.text('スタート'), findsOneWidget);
    expect(find.text('ストップ'), findsNothing);
    expect(find.text('00.00'), findsOneWidget);

    // リセットボタンをタップしてコールバックがトリガーされることを確認
    await tester.tap(find.text('リセット'));
    await tester.pump();
    expect(resetPressed, isTrue);
    expect(find.text('00.00'), findsOneWidget);

    // スタート/ストップボタンをタップしてコールバックがトリガーされることを確認
    await tester.tap(find.text('スタート'));
    await tester.pump();
    expect(startStopPressed, isTrue);
    expect(isRunning, isTrue);

    // isRunning が true のときにボタンのテキストが 'ストップ' に変わることを確認
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Text(timerText, key: Key('timerText')),
              ActionButtons(
                onStartStop: () {
                  startStopPressed = true;
                  isRunning = !isRunning;
                },
                onReset: () {
                  resetPressed = true;
                  timerText = '00.00';
                  isRunning = false; // タイマーを停止
                },
                isRunning: isRunning,
              ),
            ],
          ),
        ),
      ),
    );
    expect(find.text('ストップ'), findsOneWidget);
    expect(find.text('スタート'), findsNothing);
  });
}
