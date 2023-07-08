import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

enum GameState { readyToStart, waiting, canBeStopped }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String millisecondsText = "";
  GameState gameState = GameState.readyToStart;
  final buttonStateColors = const <GameState, Color>{
    GameState.readyToStart: Color(0xFF40CA88),
    GameState.waiting: Color(0xFFE0982D),
    GameState.canBeStopped: Color(0xFFE02D47)
  };

  Timer? waitingTimer;
  Timer? stoppableTimer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF282E3D),
        body: Stack(children: [
          const Align(
            alignment: Alignment(0, -0.8),
            child: Text(
              'Test your\nreaction speed',
              style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ColoredBox(
              color: const Color(0xFF6D6D6D),
              child: SizedBox(
                height: 200,
                width: 300,
                child: Text(
                  millisecondsText,
                  style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.8),
            child: GestureDetector(
              onTap: () => setState(() {
                switch (gameState) {
                  case GameState.readyToStart:
                    gameState = GameState.waiting;
                    millisecondsText = "";
                    _startWaitingTimer();
                    break;
                  case GameState.waiting:
                    //gameState = GameState.canBeStopped;
                    break;
                  case GameState.canBeStopped:
                    gameState = GameState.readyToStart;
                    stoppableTimer?.cancel();
                    break;
                }
              }),
              child: ColoredBox(
                color: buttonStateColors[gameState]!,
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(
                    child: Text(_getButtonText(),
                        style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  String _getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return "START";
      case GameState.waiting:
        return "WAIT";
      case GameState.canBeStopped:
        return "STOP";
    }
  }

  void _startWaitingTimer() {
    final int randomMilliseconds = Random().nextInt(4000) + 1000;
    debugPrint('$randomMilliseconds');
    waitingTimer = Timer(Duration(milliseconds: randomMilliseconds), () {
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startStoppableTimer();
    });
  }

  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = "${timer.tick * 16} ms";
      });
    });
  }

  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }
}
