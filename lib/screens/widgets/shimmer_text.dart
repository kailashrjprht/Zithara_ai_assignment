import 'package:flutter/material.dart';

class ShimmerText extends StatefulWidget {
  final String text;
  final double fontSize;

  const ShimmerText({
    super.key,
    required this.text,
    this.fontSize = 24,
  });

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -2, end: 2).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: const [
          Color(0xFF4CAF50), // Green
          Color.fromARGB(255, 43, 20, 244), // Blue
          Color.fromARGB(255, 201, 27, 27), // Gold
          Color.fromARGB(255, 255, 230, 0), // Gold
        ],
        stops: [
          0.0 + _animation.value / 4,
          0.25 + _animation.value / 4,
          0.5 + _animation.value / 4,
          1.0 + _animation.value / 4,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: Text(
        widget.text,
        style: TextStyle(fontSize: widget.fontSize, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
