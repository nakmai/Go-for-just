import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/timer_state.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
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
