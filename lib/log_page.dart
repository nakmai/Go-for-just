import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ten_second_challenge/main.dart';

class LogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerState = context.watch<TimerState>();

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
          '履歴',
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
        child: timerState.logs.isEmpty
            ? Center(
                child: Text(
                  '履歴はありません',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: timerState.logs.length,
                itemBuilder: (context, index) {
                  // 順番を逆転させる
                  final reversedIndex = timerState.logs.length - 1 - index;
                  final log = timerState.logs[reversedIndex];
                  return Card(
                    color: Colors.grey[900],
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          '${index + 1}', // 表示順は元のインデックス
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        '${log["time"]} 秒',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        log["result"] ?? '不明な結果',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
