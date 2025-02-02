import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // DeviceOrientation をインポート
import 'package:provider/provider.dart';
import 'state/timer_state.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 縦向き（ポートレートモード）のみを許可
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TimerState(),
      child: MaterialApp(
        title: '目指せジャスト',
        theme: ThemeData.dark(),
        home: HomeScreen(),
      ),
    );
  }
}
