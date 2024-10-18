import 'package:flutter/material.dart';

/// Under development
class EditPanel extends StatelessWidget {
  const EditPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {},
          child: Text('[ ]'),
        ),
        TextButton(onPressed: () {}, child: Text('Break'))
      ],
    );
  }
}
