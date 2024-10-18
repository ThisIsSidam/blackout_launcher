import 'dart:async';

import 'package:flutter/material.dart';

class ClockWidget extends StatelessWidget {
  const ClockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.sizeOf(context).height * 0.1,
          bottom: 8,
          left: 8,
          right: 8),
      child: StreamBuilder(
          stream: Stream.periodic(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            return Text(
              "${DateTime.now().hour.toString().padLeft(2, '0')}\n${DateTime.now().minute.toString().padLeft(2, '0')}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 150,
                fontWeight: FontWeight.w500,
                height: 1.0, // Minimal line height
              ),
              textAlign: TextAlign.center,
            );
          }),
    );
  }
}
