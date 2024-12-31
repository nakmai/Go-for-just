import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // 追加

import 'package:ten_second_challenge/main.dart';

void main() {
  // テスト環境でのデータベースファクトリの初期化
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // アプリをビルドしてフレームをトリガーします。
    await tester.pumpWidget(MyApp());

    // カウンターが0で始まることを確認します。
    expect(find.byKey(Key('counter')), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // '+'アイコンをタップしてフレームをトリガーします。
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // カウンターがインクリメントされたことを確認します。
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
