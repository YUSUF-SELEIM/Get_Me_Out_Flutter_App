import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('VOLUME_UP_CHANNEL');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Image.asset(
              'assets/avatar.png',
              height: 125,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Yusuf Abdelfattah",
              style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.w400, // Use a lighter font weight
              ),
            ),
            const SizedBox(
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedIconButton(
                    icon: Icons.phone,
                    color: Colors.green,
                    onPressed: () async {
                      try {
                        await platform.invokeMethod('stopFakeCall');
                      } on PlatformException catch (e) {
                        print("Failed to make fake call: '${e.message}'.");
                      }
                    },
                  ),
                  const SizedBox(
                    width: 150,
                  ),
                  AnimatedIconButton(
                    icon: Icons.phone_missed,
                    color: Colors.red,
                    onPressed: () async {
                      try {
                        await platform.invokeMethod('stopFakeCall');
                      } on PlatformException catch (e) {
                        print("Failed to make fake call: '${e.message}'.");
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  AnimatedIconButton({super.key, required this.icon, required this.color, required this.onPressed});

  @override
  _AnimatedIconButtonState createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: IconButton(
            icon: Icon(widget.icon, color: widget.color),
            iconSize: 50,
            color: Colors.white,
            onPressed: widget.onPressed,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
