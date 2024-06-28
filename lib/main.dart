import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartWatch Timer',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        hintColor: Colors.blueAccent,
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: Colors.white),
        ),
      ),
      home: const WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return TimerScreen(mode: mode);
          },
        );
      },
    );
  }
}

class TimerScreen extends StatefulWidget {
  final WearMode mode;

  const TimerScreen({required this.mode, super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  int _count = 0;
  String _strCount = "00:00";
  String _status = "Start";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isAmbient = widget.mode == WearMode.ambient;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[850],
                ),
                child: const Center(
                  child: Icon(
                    Icons.timer,
                    size: 30,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _strCount,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: isAmbient ? Colors.grey : Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              if (!isAmbient)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton.icon(
                      onPressed: _handleStartStop,
                      icon: Icon(
                        _status == "Start"
                            ? Icons.play_arrow
                            : _status == "Stop"
                                ? Icons.pause
                                : Icons.play_arrow,
                        size: 16,
                      ),
                      label: Text(
                        _status == "Start"
                            ? "Start"
                            : _status == "Stop"
                                ? "Pause"
                                : "Continue",
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _handleReset,
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text(
                        "Reset",
                        style: TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleStartStop() {
    if (_status == "Start") {
      _startTimer();
      setState(() {
        _status = "Stop";
      });
    } else if (_status == "Stop") {
      _timer.cancel();
      setState(() {
        _status = "Continue";
      });
    } else if (_status == "Continue") {
      _startTimer();
      setState(() {
        _status = "Stop";
      });
    }
  }

  void _handleReset() {
    _timer.cancel();
    setState(() {
      _count = 0;
      _strCount = "00:00";
      _status = "Start";
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _count += 1;
        int minute = _count ~/ 60;
        int second = _count % 60;
        _strCount =
            '${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
      });
    });
  }
}
