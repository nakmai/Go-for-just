import 'package:flutter/material.dart';

class LogList extends StatelessWidget {
  final List<Map<String, String>> logs;

  LogList({required this.logs});

  @override
  Widget build(BuildContext context) {
    final displayedLogs = logs.take(10).toList(); // 表示する履歴を10個に制限

    return displayedLogs.isEmpty
        ? Center(
            child: Text(
              '履歴はありません',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        : ListView.builder(
            itemCount: displayedLogs.length,
            itemBuilder: (context, index) {
              final reversedIndex = displayedLogs.length - 1 - index;
              final log = displayedLogs[reversedIndex];
              return Card(
                color: Colors.grey[900],
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    '${log["time"]}秒 - ${log["result"]}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          );
  }
}
