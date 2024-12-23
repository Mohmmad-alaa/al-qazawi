import 'package:flutter/material.dart';

class DetailIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DetailIcon({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  _DetailIconState createState() => _DetailIconState();
}

class _DetailIconState extends State<DetailIcon> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller)
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
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),   // بدء الأنميشن عند الضغط
      onTapUp: (_) => _controller.reverse(),    // انتهاء الأنميشن عند رفع الضغط
      onTapCancel: () => _controller.reverse(), // عند إلغاء الضغط
      onTap: widget.onTap,                      // استدعاء الفعل
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _animation,
            child: Icon(widget.icon, size: 40),
          ),
          const SizedBox(height: 8),
          Text(widget.label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
