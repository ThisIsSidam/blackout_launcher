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
      child: StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1)),
        builder: (context, snapshot) {
          return Text(
            DateTime.now().toString().substring(10, 19),
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