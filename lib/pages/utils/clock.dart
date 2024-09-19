import 'dart:async';

import 'package:flutter/material.dart';

class ClockWidget extends StatelessWidget {
  const ClockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.sizeOf(context).height * 0.1,
        bottom: 8, left: 8, right: 8
      ),
      child: StatefulBuilder(
        builder: (context, setState) {

          int secondsRemaining = 60 - DateTime.now().second;
          Timer.periodic(Duration(seconds: secondsRemaining), (timer_0) {

            setState(() {});

            Timer.periodic(const Duration(minutes: 1), (timer) {
              setState(() {});
            });

            timer_0.cancel();
          });

          return Text(
            DateTime.now().toString().substring(10, 16),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 64,
            ),
          );
        }
      ),
    );
  }
}