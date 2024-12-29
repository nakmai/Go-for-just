import 'package:ten_second_challenge/performance_page.dart';
import 'package:ten_second_challenge/log_page.dart'; // 修正: LogPageをインポート
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimerState(),
      child: MaterialApp(
        title: '目指せジャスト',
        theme: ThemeData(),
        home: MyHomePage(),
      ),
    );
  }
}

class TimerState extends ChangeNotifier {
  Timer? _timer;
  int _milliseconds = 0;
  bool _isRunning = false;

  // 成績データ
  int _totalPlays = 0;
  int _totalPerfect = 0;
  int _totalSuccess = 0;
  int _totalFails = 0;

  // 履歴データ
  final List<Map<String, String>> _logs = [];

  int get milliseconds => _milliseconds;
  bool get isRunning => _isRunning;

  int get totalPlays => _totalPlays;
  int get totalPerfect => _totalPerfect;
  int get totalSuccess => _totalSuccess;
  int get totalFails => _totalFails;

  List<Map<String, String>> get logs => _logs;

  void startTimer() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      _milliseconds += 10;
      notifyListeners();
    });
  }

  void stopTimer(int targetSeconds) {
    if (!_isRunning) return;
    _isRunning = false;
    _timer?.cancel();

    double elapsedSeconds = _milliseconds / 1000.0;
    _totalPlays++;

    // 成績の判定
    const successThreshold = 0.15;
    const perfectThreshold = 0.01;

    String result;
    if ((elapsedSeconds - targetSeconds).abs() <= perfectThreshold) {
      _totalPerfect++;
      result = '大成功';
    } else if ((elapsedSeconds - targetSeconds).abs() <= successThreshold) {
      _totalSuccess++;
      result = '成功';
    } else {
      _totalFails++;
      result = '失敗';
    }

    // 履歴を追加
    _logs.insert(0, {
      "time": elapsedSeconds.toStringAsFixed(2),
      "result": result,
    });
    if (_logs.length > 10) {
      _logs.removeLast();
    }

    notifyListeners();
  }

  void resetTimer() {
    _isRunning = false;
    _timer?.cancel();
    _milliseconds = 0;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _targetSeconds = 10;
  bool _isTimeVisible = true;
  bool _isTimerStopped = true;

  String _getResultText(double elapsedSeconds) {
    const successThreshold = 0.15;
    const perfectThreshold = 0.01;

    if (!_isTimerStopped || elapsedSeconds == 0.0) return '';

    if ((elapsedSeconds - _targetSeconds).abs() <= perfectThreshold) {
      return '🎊 大 成 功 🎊';
    } else if ((elapsedSeconds - _targetSeconds).abs() <= successThreshold) {
      return '成功!';
    } else {
      return '失敗...';
    }
  }

  void _showNumberKeyboard(BuildContext context) {
    final TextEditingController _controller =
        TextEditingController(text: _targetSeconds.toString());
    final FocusNode _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: EdgeInsets.all(12), // 縦幅を狭くする
            color: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: '1〜59の数字を入力',
                      hintStyle: TextStyle(
                        fontSize: 18,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final int? newSeconds = int.tryParse(_controller.text);
                    if (newSeconds != null &&
                        newSeconds >= 1 &&
                        newSeconds <= 59) {
                      setState(() {
                        _targetSeconds = newSeconds;
                      });
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('1〜59の数字を入力してください'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Text(
                        '変更',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 0.5
                            ..color = Colors.white,
                        ),
                      ),
                      Text(
                        '変更',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPopupMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // ダイアログの角丸
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, // 幅を画面の80%に設定
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 必要なサイズだけ確保
              children: [
                ListTile(
                  title: const Text(
                    '秒数変更',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(); // ダイアログを閉じる
                    _showNumberKeyboard(context); // 数字変更キーボードを呼び出し
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    '成績',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(); // ダイアログを閉じる
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PerformancePage()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    '履歴',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(); // ダイアログを閉じる
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogPage()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    'タイトル',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(); // ダイアログを閉じる
                    setState(() {
                      _targetSeconds = 10; // 目標秒数を初期値に戻す
                      _isTimerStopped = true; // タイマー停止状態に設定
                      context.read<TimerState>().resetTimer(); // タイマーをリセット
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var timerState = context.watch<TimerState>();
    double elapsedSeconds = timerState.milliseconds / 1000;
    String resultText = _getResultText(elapsedSeconds);

    return Scaffold(
      appBar: AppBar(
        title: null,
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/setting_icon.png', // カスタムアイコン
              width: 24,
              height: 24,
            ),
            onPressed: () => _showPopupMenu(context), // メソッド呼び出し
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OutlineText(
              text: '目指せジャスト',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 10),
            OutlineText(
              text: '$_targetSeconds秒',
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 10),
            OutlineText(
              text: resultText,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...((timerState.milliseconds / 1000)
                    .toStringAsFixed(2)
                    .padLeft(5, '0')
                    .split('')
                    .map((char) {
                  return Container(
                    width: 35,
                    alignment: Alignment.center,
                    child: Text(
                      char,
                      style: TextStyle(
                        fontSize: 60,
                        color: _isTimeVisible ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  );
                }).toList()),
                SizedBox(width: 10),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '秒',
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // ボタンを中央に配置
              children: [
                SizedBox(
                  width: 150, // 横幅を適切に設定
                  child: ElevatedButton(
                    onPressed: () {
                      timerState.resetTimer();
                      setState(() {
                        _isTimerStopped = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12), // ボタンの縦幅を設定
                    ),
                    child: OutlineText(
                      text: 'リセット',
                      fontSize: 20, // フォントサイズを調整
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 16), // ボタン間のスペース
                SizedBox(
                  width: 150, // 横幅を適切に設定
                  child: ElevatedButton(
                    key: const Key('startButton'),
                    onPressed: () {
                      if (timerState.isRunning) {
                        timerState.stopTimer(_targetSeconds);
                        setState(() {
                          _isTimerStopped = true;
                        });
                      } else {
                        timerState.startTimer();
                        setState(() {
                          _isTimerStopped = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12), // ボタンの縦幅を設定
                    ),
                    child: OutlineText(
                      text: timerState.isRunning ? 'ストップ' : 'スタート',
                      key: const Key('startButtonText'),
                      fontSize: 20, // フォントサイズを調整
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            TextButton(
              onPressed: () {
                setState(() {
                  _isTimeVisible = !_isTimeVisible;
                });
              },
              child: OutlineText(
                text: _isTimeVisible ? '秒数を表示しない' : '秒数を表示する',
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OutlineText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const OutlineText({
    Key? key,
    required this.text,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = Colors.white,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
