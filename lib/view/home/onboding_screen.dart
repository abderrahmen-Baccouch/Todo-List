import 'dart:ui';
import 'package:ToDo/view/home/home_view.dart';
import 'package:ToDo/view/home/widgets/animated_btn.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class OnbodingScreen extends StatefulWidget {
  const OnbodingScreen({super.key});

  @override
  State<OnbodingScreen> createState() => _OnbodingScreenState();
}

class _OnbodingScreenState extends State<OnbodingScreen> {
  late RiveAnimationController _btnAnimationController;

  bool isShowSignInDialog = false;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Positioned(
          //   width: MediaQuery.of(context).size.width * 1.7,
          //   left: 100,
          //   bottom: 100,
          //   child: Image.asset(
          //     "assets/Backgrounds/Spline.png",
          //   ),
          // ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: const SizedBox(),
            ),
          ),
           const RiveAnimation.asset(
             "assets/RiveAssets/shapes.riv",
           ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
       Positioned(
  top: 30,
  left: 0,
  right: 0,
  child: Container(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Transform.scale(
        scale: 0.8, // Adjust the scale factor as needed
        child: Image.asset(
          "assets/img/checklist.png",
          fit: BoxFit.cover,
        ),
      ),
    ),
  ),
),

 Positioned(
  top: 20,
  left: 0,
  right: 0,
  child: Container(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Transform.scale(
        scale: 0.6, // Adjust the scale factor as needed
        child: Image.asset(
          "assets/img/ic5.png",
          fit: BoxFit.cover,
        ),
      ),
    ),
  ),
),



          AnimatedPositioned(
            top: isShowSignInDialog ? -50 : 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            duration: const Duration(milliseconds: 260),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 260,
                      child: Column(
  crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
  children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 80.0, right: 110),
          child: Text(
            "ToDo",
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.w700,
              fontFamily: "Poppins",
              height: 1.2,
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(-3.0, -20.0), // Ajustez le décalage vers le haut selon votre besoin
          child: Padding(
            padding: EdgeInsets.only(bottom: 20.0, left: 13),
            child: Text(
              "List &",
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w700,
                fontFamily: "Poppins",
                // height: 1.2,
              ),
            ),
          ),
        ),
      ],
    ),
    SizedBox(height: 0),
   Transform.translate(
          offset: Offset(0, -30.0), // Ajustez le décalage vers le haut selon votre besoin
          child: Text(
      "Don't miss out on the efficiency shift \n– step into smarter, more empowered task management with innovative technologies",
    ),
    ),
  ],
),
                  ),
                    const Spacer(flex: 2),
                    AnimatedBtn(
                      btnAnimationController: _btnAnimationController,
                      press: () {
                        _btnAnimationController.isActive = true;

                        Future.delayed(
                          const Duration(milliseconds: 800),
                          () {
                            setState(() {
                              isShowSignInDialog = true;
                            });

                            Navigator.push(
                              context,
                               MaterialPageRoute(builder: (context) => HomeView()),
                                  );
                          
                          },
                        );
                      },
                    ),
                   const Padding(
  padding: EdgeInsets.symmetric(vertical: 24),
  child: Text(
    "© 2024 ToDo List. All rights reserved.",
    style: TextStyle(
      color: Colors.grey,
      fontSize: 12,
      
    ),
   
  ),
),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
