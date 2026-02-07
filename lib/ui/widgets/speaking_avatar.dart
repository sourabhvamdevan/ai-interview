import 'package:flutter/material.dart';

class SpeakingAvatar extends StatefulWidget {
  final bool isSpeaking;

  const SpeakingAvatar({super.key, required this.isSpeaking});

  @override
  State<SpeakingAvatar> createState() => _SpeakingAvatarState();
}

class _SpeakingAvatarState extends State<SpeakingAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    if (widget.isSpeaking) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant SpeakingAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpeaking) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(
        begin: 1.0,
        end: 1.1,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: CircleAvatar(
        radius: 45,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.person, size: 50, color: Colors.white),
      ),
    );
  }
}
