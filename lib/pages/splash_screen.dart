import 'package:final_project/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _cartController;
  bool cartAnimated = false;
  bool animateCartText = false;

  @override
  void initState() {
    super.initState();
    _cartController = AnimationController(vsync: this);
    _cartController.addListener(() {
      if (_cartController.value > 0.7) {
        _cartController.stop();
        cartAnimated = true;
        setState(() {});
        Future.delayed(const Duration(seconds: 2), () {
          animateCartText = true;
          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cartController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          // White Container top half
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            height: cartAnimated ? screenHeight / 1.9 : screenHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(cartAnimated ? 40.0 : 0.0)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Visibility(
                  visible: !cartAnimated,
                  child: Lottie.asset(
                    'assets/lottie/shop.json',
                    frameRate: FrameRate.max,
                    height: 190.0,
                    width: 190.0,
                    controller: _cartController,
                    onLoaded: (composition) {
                      _cartController
                        ..duration = composition.duration
                        ..forward();
                    },
                  ),
                ),
                Visibility(
                  visible: cartAnimated,
                  child: Image.asset(
                    'assets/lottie/cartpic.png',
                    height: 190.0,
                    width: 190.0,
                  ),
                ),
                Center(
                  child: AnimatedOpacity(
                    opacity: animateCartText ? 1 : 0,
                    duration: const Duration(seconds: 2),
                    child: Text(
                      ' P O S',
                      style: TextStyle(
                          fontSize: 50.0,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Text bottom part
          Visibility(visible: cartAnimated, child: const _BottomPart()),
        ],
      ),
    );
  }
}

class _BottomPart extends StatelessWidget {
  const _BottomPart();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Text(
            //   'Find The Best Goods for You',
            //   style: TextStyle(
            //       fontSize: 27.0,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.white),
            // ),

            const SizedBox(height: 30.0),
            Text(
              'Best Place Where you can store all your Products, Clients and Orders ',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white.withOpacity(0.8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 50.0),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                },
                child: Container(
                  height: 85.0,
                  width: 85.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.0),
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    size: 50.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
