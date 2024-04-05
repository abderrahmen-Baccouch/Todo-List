import 'package:ToDo/view/home/home_view.dart';
import 'package:ToDo/view/home/onboding_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class splashScreen extends StatelessWidget {
  const splashScreen({super.key});
get splash => null ;
  @override
  Widget build(BuildContext context) {
   return AnimatedSplashScreen(
  splash: Padding(
    padding: const EdgeInsets.all(0.0),
    child: Center(
        child:
         
          LottieBuilder.asset(
              'assets/lottie/Animation - 1711070291232.json',
            height: 500,
            width: 500,
            ),
          
        
      ),
  ),
  
  nextScreen: const OnbodingScreen(),
  backgroundColor: Color.fromARGB(255, 255, 255, 255),
  duration: 3800,
);

     
  }
}