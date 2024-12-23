import 'package:alqhazawi/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // إعداد الفيديو
    _controller = VideoPlayerController.asset("assets/video/logoAnimated.mp4")
      ..initialize().then((_) {
        setState(() {});
        _controller.play(); // تشغيل الفيديو تلقائيًا
      });

    // الانتقال إلى الصفحة التالية بعد انتهاء الفيديو
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        _navigateToNextPage();
      }
    });
  }

  void _navigateToNextPage() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => LoginPage(), // الصفحة التالية
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation, // انتقال سلس عبر التلاشي
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // تحرير الموارد عند الخروج
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // جعل الخلفية سوداء
      body: Stack(
        children: [
          // عرض الفيديو بشكل كامل
          if (_controller.value.isInitialized)
            Center(
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover, // ملء الشاشة مع اقتصاص الزوائد
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            )
          else
            Center(child: CircularProgressIndicator(color: Colors.white)), // أثناء تحميل الفيديو


        ],
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الصفحة التالية"),
      ),
      body: Center(
        child: Text("مرحبًا بك في الصفحة التالية!"),
      ),
    );
  }
}
