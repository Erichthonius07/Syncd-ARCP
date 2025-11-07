import 'package:flutter/material.dart';

class PulsingButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const PulsingButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<PulsingButton> createState() => _PulsingButtonState();
}

class _PulsingButtonState extends State<PulsingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true); // This makes it pulse in and out

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          child: Text(widget.text),
        ),
      ),
    );
  }
}