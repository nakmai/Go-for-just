import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:ten_second_challenge/screens/performance_screen.dart';
import 'package:ten_second_challenge/screens/log_screen.dart';
import 'package:ten_second_challenge/state/timer_state.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              'assets/setting_icon.png', // カスタムアイコン画像を設定
              width: 24,
              height: 24,
            ),
            onPressed: () => _showPopupMenu(context), // ポップアップメニューを呼び出し
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '目指せジャスト',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '$_targetSeconds秒',
              style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              resultText,
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(
                      char,
                      style: TextStyle(
                        fontSize: 60,
                        color: _isTimeVisible ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        letterSpacing: 7.0, // 文字間隔を広げる
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
                      fontSize: 40,
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
                  width: 150,
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
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'リセット',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    key: const Key('startButton'),
                    onPressed: () {
                      if (timerState.isRunning) {
                        timerState.stopTimer(_targetSeconds);
                        setState(() {
                          _isTimerStopped = true;
                          _isTimeVisible = true; // ストップボタンを押した時に秒数を表示
                        });
                      } else {
                        timerState.startTimer();
                        setState(() {
                          _isTimerStopped = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: timerState.isRunning
                          ? Colors.green
                          : Colors.green, // ストップボタンを青色、スタートボタンを緑色に変更
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      timerState.isRunning ? 'ストップ' : 'スタート',
                      key: const Key('startButtonText'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
              child: Text(
                _isTimeVisible ? '秒数を表示しない' : '秒数を表示する',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
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
                          builder: (context) => PerformanceScreen()),
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
                      MaterialPageRoute(builder: (context) => LogScreen()),
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
                      color: Colors.black, // テキストカラーを黒に設定
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
                  child: Text(
                    '変更',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
