import 'package:flutter/cupertino.dart' as icon;
import 'package:flutter/material.dart';
import 'package:wether_app/screens/City-selection%20_screen.dart';


class Splashscreen extends icon.StatefulWidget {
  const Splashscreen({super.key});

  @override
  icon.State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends icon.State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    loading();
  }

  Future<void> loading() async {
    await Future.delayed(const Duration(seconds: 5));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const CitySelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF81D4FA), // Light sky blue
              Color(0xFF0288D1), // Darker blue
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Cloud Icon
                    Icon(
                      icon.CupertinoIcons.cloud_sun,
                      size: 100,
                      color: Colors.white,
                    ),

                    const SizedBox(height: 20),

                    // App Name
                    const Text(
                      'Weather App',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 5,
                            color: Colors.black38,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Loading Text with Animated Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Loading',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(width: 5),

                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: 3),
                          duration: const Duration(seconds: 1),
                          builder: (context, value, child) {
                            return Text(
                              '.' * value.toInt(),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Developer Credit
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Developed by: Muhammad Moaz",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}