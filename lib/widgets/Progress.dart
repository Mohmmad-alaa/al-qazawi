import 'package:flutter/material.dart';

class ProgressIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double progress;

  const ProgressIcon({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.progress, // نسبة الإنجاز من 0 إلى 1.
  }) : super(key: key);

  // دالة لتحديد لون المؤشر بناءً على نسبة الإنجاز.
  Color getProgressColor(double progress) {
    if (progress < 0.3) return Colors.red;
    if (progress < 0.7) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // المؤشر الدائري.
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    getProgressColor(progress),
                  ),
                ),
              ),
              // الأيقونة داخل المؤشر.
              Icon(icon, size: 30, color: getProgressColor(progress)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
