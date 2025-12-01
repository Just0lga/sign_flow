import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final dynamic localeProvider; // dışarıdan alıyorsan ekle

  const SplashScreen({super.key, this.localeProvider});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    // Fade animasyonu
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    // 3 saniye sonra yönlendirme
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(localeProvider: widget.localeProvider),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _opacity,
          child: Image.asset("assets/Sign Flow.png"),
        ),
      ),
    );
  }
}

// Örnek hedef sayfa (senin kodunda zaten var)
class HomeScreen extends StatelessWidget {
  final dynamic localeProvider;
  const HomeScreen({super.key, required this.localeProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Home Screen")));
  }
}
