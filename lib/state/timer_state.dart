import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../db/db_helper.dart';

class TimerState extends ChangeNotifier {
  late Ticker _ticker;
  int _milliseconds = 0;
  bool _isRunning = false;

  // 成績データ
  int _totalPlays = 0;
  int _totalPerfect = 0;
  int _totalSuccess = 0;
  int _totalFails = 0;

  // 履歴データ
  final List<Map<String, String>> _logs = [];

  final DBHelper _dbHelper = DBHelper();

  int get milliseconds => _milliseconds;
  bool get isRunning => _isRunning;

  // 成績データのゲッター
  int get totalPlays => _totalPlays;
  int get totalPerfect => _totalPerfect;
  int get totalSuccess => _totalSuccess;
  int get totalFails => _totalFails;

  // 履歴データのゲッター
  List<Map<String, String>> get logs => _logs;

  TimerState() {
    _loadData();
  }

  Future<void> _loadData() async {
    // 履歴データを読み込む
    final history = await _dbHelper.getHistory();
    _logs.clear();
    _logs.addAll(history.map((entry) => {
          'time': entry['time'] as String,
          'result': entry['result'] as String,
        }));

    // 成績データを更新
    _totalPlays = _logs.length;
    _totalPerfect = _logs.where((log) => log['result'] == '🎊 大 成 功 🎊').length;
    _totalSuccess = _logs.where((log) => log['result'] == '成功').length;
    _totalFails = _logs.where((log) => log['result'] == '失敗').length;

    // 成績データを保存
    await _dbHelper.saveSummary({
      'totalPlays': _totalPlays,
      'totalPerfect': _totalPerfect,
      'totalSuccess': _totalSuccess,
      'totalFails': _totalFails,
    });

    notifyListeners();
  }

  void startTimer() {
    if (_isRunning) return;
    _isRunning = true;
    _ticker = Ticker((elapsed) {
      _milliseconds = (elapsed.inMilliseconds ~/ 10) * 10;
      notifyListeners();
    });
    _ticker.start();
  }

  void stopTimer(int targetSeconds) async {
    if (!_isRunning) return;
    _isRunning = false;
    _ticker.stop();

    double elapsedSeconds = _milliseconds / 1000.0;
    _totalPlays++;

    // 成績の判定
    const successThreshold = 0.15;
    const perfectThreshold = 0.01;

    String result;
    if ((elapsedSeconds - targetSeconds).abs() <= perfectThreshold) {
      result = '🎊 大 成 功 🎊';
      _totalPerfect++;
    } else if ((elapsedSeconds - targetSeconds).abs() <= successThreshold) {
      result = '成功';
      _totalSuccess++;
    } else {
      result = '失敗';
      _totalFails++;
    }

    // 履歴を追加
    await _dbHelper.insertHistory(elapsedSeconds.toStringAsFixed(2), result);
    _logs.insert(
        0, {"time": elapsedSeconds.toStringAsFixed(2), "result": result});
    if (_logs.length > 10) _logs.removeLast();

    // 成績を保存
    await _dbHelper.saveSummary({
      'totalPlays': _totalPlays,
      'totalPerfect': _totalPerfect,
      'totalSuccess': _totalSuccess,
      'totalFails': _totalFails,
    });

    notifyListeners();
  }

  void resetTimer() {
    _isRunning = false;
    _milliseconds = 0;
    _ticker.stop(); // タイマーが稼働中でも停止
    notifyListeners();
  }

  Future<void> clearLogs() async {
    await _dbHelper.clearHistory();
    _logs.clear();
    _totalPlays = 0;
    _totalPerfect = 0;
    _totalSuccess = 0;
    _totalFails = 0;

    await _dbHelper.saveSummary({
      'totalPlays': _totalPlays,
      'totalPerfect': _totalPerfect,
      'totalSuccess': _totalSuccess,
      'totalFails': _totalFails,
    });

    notifyListeners();
  }
}
