import 'package:flutter/material.dart';

class MicControls extends StatelessWidget {
  final VoidCallback onListen;
  final VoidCallback onSpeak;

  const MicControls({super.key, required this.onListen, required this.onSpeak});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.mic, color: Colors.blueAccent),
          onPressed: onListen,
        ),
        IconButton(
          icon: const Icon(Icons.volume_up, color: Colors.greenAccent),
          onPressed: onSpeak,
        ),
      ],
    );
  }
}
