import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test task hello world',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  final String textContent = "Hello world";

  int colorBlueValue = 0;
  int colorRedValue = 0;
  int colorGreenValue = 0;
  Random rng = Random();

  int prevColorRedValue = 0;
  int prevColorGreenValue = 0;
  int prevColorBlueValue = 0;

  double rotationAngle = 0;

  void _randomizeColor() {
    colorBlueValue = rng.nextInt(255);
    colorRedValue = rng.nextInt(255);
    colorGreenValue = rng.nextInt(255);
  }

  void rotateText() {
    setState(() {
      rotationAngle = rotationAngle == 2 * pi ? 0 : 2 * pi;
    });
  }

  void changeColor() {
    setState(() {
      _controller.forward(from: 0);
      _randomizeColor();
    });
  }

  @override
  void initState() {
    _controller.addListener(() {
      if (_controller.value > 0.95) {
        prevColorBlueValue = colorBlueValue;
        prevColorGreenValue = colorGreenValue;
        prevColorRedValue = colorRedValue;
      }
    });
    super.initState();
    changeColor();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: changeColor,
        child: AnimatedBuilder(
            animation: _controller,
            builder: (context, widget) {
              int numCharsToShow =
                  (_controller.value * textContent.length).ceil();

              return Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          stops: [
                        _controller.value,
                        1
                      ],
                          colors: [
                        Color.fromRGBO(
                            colorRedValue, colorGreenValue, colorBlueValue, 1),
                        Color.fromRGBO(prevColorRedValue, prevColorGreenValue,
                            prevColorBlueValue, 1),
                      ])),
                  child: Center(
                      child: GestureDetector(
                    onTap: rotateText,
                    child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: rotationAngle),
                        duration: const Duration(milliseconds: 1500),
                        builder: (context, angle, widget) {
                          return Transform.rotate(
                            angle: angle,
                            child: Text(
                              textContent.substring(0, numCharsToShow),
                              style: TextStyle(
                                  color: Color.fromRGBO(
                                      255 - colorRedValue,
                                      255 - colorGreenValue,
                                      255 - colorBlueValue,
                                      1),
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  shadows: const [
                                    Shadow(
                                      offset: Offset(3.0, 0.0),
                                      blurRadius: 5.0,
                                      color: Color.fromRGBO(0, 0, 0, 0.6),
                                    ),
                                  ]),
                            ),
                          );
                        }),
                  )));
            }),
      ),
    );
  }
}
