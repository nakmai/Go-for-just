import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ten_second_challenge/main.dart'; // TimerState を使用するためにインポート

class PerformancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerState = context.watch<TimerState>();

    int totalPlays = timerState.totalPlays;
    int totalPerfect = timerState.totalPerfect;
    int totalSuccess = timerState.totalSuccess;
    int totalFails = timerState.totalFails;

    int successPlusPerfect = totalPerfect + totalSuccess;

    double totalRate = totalPlays > 0 ? 100 : 0;
    double successPlusPerfectRate =
        totalPlays > 0 ? (successPlusPerfect / totalPlays) * 100 : 0;
    double perfectRate = totalPlays > 0 ? (totalPerfect / totalPlays) * 100 : 0;
    double successRate = totalPlays > 0 ? (totalSuccess / totalPlays) * 100 : 0;
    double failRate = totalPlays > 0 ? (totalFails / totalPlays) * 100 : 0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'assets/left_arrow_icon.png', // アイコン画像を設定
            width: 24, // アイコンの幅
            height: 24, // アイコンの高さ
          ),
          onPressed: () {
            Navigator.pop(context); // 戻る動作を実行
          },
        ),
        title: const Text(
          '成績',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0, // AppBarの影をなくす
        centerTitle: true, // タイトルを中央揃え
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow('遊んだ回数', totalPlays, totalRate),
            _buildStatRow('成功＋大成功', successPlusPerfect, successPlusPerfectRate),
            const SizedBox(height: 40), // 2行分の間隔を追加
            _buildStatRow('大成功', totalPerfect, perfectRate),
            _buildStatRow('成功', totalSuccess, successRate),
            _buildStatRow('残念', totalFails, failRate),
            const SizedBox(height: 60), // 残念とタイトルボタンの間を1秒（約60px分）空ける
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Stack(
                  children: [
                    Text(
                      'タイトル',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 0.5
                          ..color = Colors.white,
                      ),
                    ),
                    Text(
                      'タイトル',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, int value, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22, // フォントサイズを大きく調整
              fontWeight: FontWeight.bold, // 太字にする
            ),
          ),
          Text(
            '$value 回 / ${percentage.toStringAsFixed(1)}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22, // フォントサイズを大きく調整
              fontWeight: FontWeight.bold, // 太字にする
            ),
          ),
        ],
      ),
    );
  }
}
