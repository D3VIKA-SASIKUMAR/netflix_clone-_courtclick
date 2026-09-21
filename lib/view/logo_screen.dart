import 'package:flutter/material.dart';

class LogoScreen extends StatefulWidget {
  static const path = '/LogoScreen';

  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 45, left: 25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 30),
                  Image.asset('assets/images/logos_netflix.png', height: 45),
                  Image.asset(
                    'assets/images/Vector.png',
                    width: 25,
                    height: 25,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 105),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                profile(
                  image: 'assets/images/Rectangle 2.png',
                  name: 'Emenalo',
                ),
                const SizedBox(width: 32),
                profile(image: 'assets/images/Rectangle 3.png', name: 'Onyeka'),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                profile(image: 'assets/images/Rectangle 4.png', name: 'Thelma'),
                const SizedBox(width: 32),
                profile(image: 'assets/images/Rectangle 5.png', name: 'Kids'),
              ],
            ),
            const SizedBox(height: 75),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 80),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/Group 1.png',
                      width: 52,
                      height: 62,
                    ),

                    const SizedBox(height: 15),
                    const Text(
                      'Add Profile',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profile({required String image, required String name}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/main_navigation');
      },
      child: Column(
        children: [
          Image.asset(image, width: 117, height: 110, fit: BoxFit.cover),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}
