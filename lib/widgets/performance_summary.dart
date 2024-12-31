import 'package:flutter/material.dart';

class PerformanceSummary extends StatelessWidget {
  final int totalPlays;
  final int totalPerfect;
  final int totalSuccess;
  final int totalFails;

  PerformanceSummary({
    required this.totalPlays,
    required this.totalPerfect,
    required this.totalSuccess,
    required this.totalFails,
  });

  @override
  Widget build(BuildContext context) {
    int totalSuccessCount = totalPerfect + totalSuccess;
    double perfectPercentage =
        totalPlays > 0 ? (totalPerfect / totalPlays) * 100 : 0;
    double successPercentage =
        totalPlays > 0 ? (totalSuccess / totalPlays) * 100 : 0;
    double failPercentage =
        totalPlays > 0 ? (totalFails / totalPlays) * 100 : 0;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('遊んだ回数: $totalPlays', style: _textStyle()),
          Text('成功回数: $totalSuccessCount', style: _textStyle()),
          SizedBox(height: 20),
          Text('大成功: $totalPerfect (${perfectPercentage.toStringAsFixed(1)}%)',
              style: _textStyle()),
          Text('成功: $totalSuccess (${successPercentage.toStringAsFixed(1)}%)',
              style: _textStyle()),
          Text('失敗: $totalFails (${failPercentage.toStringAsFixed(1)}%)',
              style: _textStyle()),
        ],
      ),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      fontSize: 20,
      color: Colors.white,
    );
  }
}
