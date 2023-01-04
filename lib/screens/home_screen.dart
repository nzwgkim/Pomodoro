import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const sec2500 = 1500;
  int totalSeconds = sec2500; // 25분 == 1500 초
  late Timer timer;
  bool isRunning = false;
  int totalPomodoro = 0;

  void OnTick(Timer timer) {
    setState(() {
      if (totalSeconds != 0) {
        totalSeconds = totalSeconds - 1;
      } else {
        totalPomodoro = totalPomodoro + 1;
        isRunning = false;
        totalSeconds = sec2500;
        timer.cancel();
      }
    });
  }

  void onStartPressed() {
    if (!isRunning) {
      timer = Timer.periodic(const Duration(seconds: 1), OnTick);
    }
    isRunning = true;
  }

  void onPausePressed() {
    if (timer.isActive) {
      timer.cancel();
      setState(() {
        isRunning = false;
      });
    }
  }

  void onResetPressed() {
    setState(() {
      totalPomodoro = 0;
      isRunning = false;
      totalSeconds = sec2500;
      timer.cancel();
    });
  }

  String format(int sec) {
    var dur = Duration(seconds: sec);
    // print(dur.toString().split('.').first.substring(2, 7));
    // substring(int start, [int? end]) → String
    // The substring of this string from [start], inclusive, to [end], exclusive.
    return dur.toString().split('.').first.substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                format(totalSeconds),
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 89,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 120,
                        color: Theme.of(context).cardColor,
                        onPressed: isRunning ? onPausePressed : onStartPressed,
                        icon: isRunning
                            ? const Icon(Icons.pause_circle_outline)
                            : const Icon(Icons.play_circle_outline),
                      ),
                      IconButton(
                        iconSize: 120,
                        color: Theme.of(context).cardColor,
                        onPressed: onResetPressed,
                        icon:
                            const Icon(Icons.settings_backup_restore_outlined),
                      ),
                    ],
                  ),
                  TimerBuilder.periodic(
                    const Duration(seconds: 1),
                    builder: (context) {
                      return Text(
                        formatDate(
                            DateTime.now(), [hh, ':', nn, ':', ss, ' ', am]),
                        style: TextStyle(
                          color: Theme.of(context).cardColor,
                          fontSize: 50,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pomodoros',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.headline1!.color,
                          ),
                        ),
                        Text(
                          '$totalPomodoro',
                          style: TextStyle(
                            fontSize: 58,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.headline1!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
