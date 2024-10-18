import 'package:blackout_launcher/feature/Notes/widget/notes_section.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [SizedBox(height: 16), NotesSection()],
        ),
      ),
    ));
  }
}
