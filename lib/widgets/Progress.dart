import 'package:flutter/material.dart';

class ProgressIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double percentage; // نسبة الإنجاز من 0 إلى 100.

  const ProgressIcon({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.percentage, // نسبة الإنجاز من 0 إلى 100.
  }) : super(key: key);

  // دالة لتحويل النسبة المئوية إلى نسبة بين 0 و 1.
  double _convertPercentageToProgress(double percentage) {
    return percentage / 100;
  }


  // دالة لتحديد لون المؤشر بناءً على نسبة الإنجاز.
  Color getProgressColor(double progress) {
    if (progress < 0.3) return Colors.red;
    if (progress < 0.7) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    double progress = _convertPercentageToProgress(percentage); // تحويل النسبة المئوية إلى نسبة بين 0 و 1.

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
