import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

// アプリケーションのエントリーポイント
// StatelessWidgetを使ってアプリ全体の構造を定義
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // TimerStateをプロバイダとしてアプリ全体に提供
      create: (context) => TimerState(),
      child: MaterialApp(
        title: '10秒チャレンジ',
        theme: ThemeData(
          // Material 3 デザインを有効化し、色を設定
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        // ホーム画面としてMyHomePageを設定
        home: MyHomePage(),
      ),
    );
  }
}

// タイマーの状態管理クラス
class TimerState extends ChangeNotifier {
  Timer? _timer; // 定期実行するTimerのインスタンス
  int _milliseconds = 0; // 経過時間をミリ秒単位で記録
  bool _isRunning = false; // タイマーが動作中かどうかを示す

  int get milliseconds => _milliseconds; // 現在の経過時間を取得
  bool get isRunning => _isRunning; // タイマーの動作状態を取得

  // タイマーを開始するメソッド
  void startTimer() {
    if (_isRunning) return; // 既に動作中なら何もしない
    _isRunning = true; // 動作中フラグをセット
    // 10ミリ秒ごとに経過時間を増加
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      _milliseconds += 10;
      notifyListeners(); // 状態が変わったことを通知
    });
  }

  // タイマーを停止するメソッド
  void stopTimer() {
    if (!_isRunning) return; // 動作中でなければ何もしない
    _isRunning = false; // 動作中フラグを解除
    _timer?.cancel(); // タイマーをキャンセル
    notifyListeners(); // 状態が変わったことを通知
  }

  // タイマーをリセットするメソッド
  void resetTimer() {
    _isRunning = false; // 動作中フラグを解除
    _timer?.cancel(); // タイマーをキャンセル
    _milliseconds = 0; // 経過時間をリセット
    notifyListeners(); // 状態が変わったことを通知
  }
}

// ホーム画面のUIを定義
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TimerStateの状態を取得
    var timerState = context.watch<TimerState>();

    return Scaffold(
      appBar: AppBar(
        // アプリバーのタイトルを設定
        title: Text('10秒チャレンジ'),
      ),
      body: Center(
        // 中央にUI要素を配置
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 経過時間を秒単位で表示
            Text(
              '${(timerState.milliseconds / 1000).toStringAsFixed(2)} 秒',
              style: TextStyle(fontSize: 48), // 大きな文字サイズ
            ),
            SizedBox(height: 20), // スペースを追加
            // タイマーの開始/停止ボタン
            ElevatedButton(
              onPressed: timerState.isRunning
                  ? timerState.stopTimer // タイマーが動作中なら停止
                  : timerState.startTimer, // タイマーが停止中なら開始
              child: Text(timerState.isRunning ? 'ストップ' : 'スタート'),
            ),
            SizedBox(height: 20), // スペースを追加
            // タイマーのリセットボタン
            ElevatedButton(
              onPressed: timerState.resetTimer, // リセットを呼び出す
              child: Text('リセット'),
            ),
          ],
        ),
      ),
    );
  }
}
