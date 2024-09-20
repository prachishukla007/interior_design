import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:interior_design/core/utils/preference.dart';
import 'package:interior_design/navigator/navigator_services.dart';
import 'package:interior_design/routes/route_manager.dart';
import 'package:interior_design/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../model/item_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    getItems();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 0.5)
        .chain(
          CurveTween(curve: Curves.fastEaseInToSlowEaseOut),
        )
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  getItems() async {
    await context.read<HomeViewModel>().loadItemsData();
    Timer(Duration(seconds: 3), ()  {
      appNavigator.pushReplacementNamed(Routes.wrapper);

    });


  }
  double pi = 3.1415926535897932;




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffFFFFF0),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // height: 600,
              //   width: 600,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Center(
                    child:
                  ClipRRect(
                   borderRadius: BorderRadius.circular(20),
                   child: Image.asset(
                     fit: BoxFit.cover,
                     "assets/images/app-icon.png",
                     height: 400,
                     width: 400,
                   ).animate(onPlay: (controller) => controller.repeat())
                       .effect(duration: 4000.ms) // this "pads out" the total duration
                       .effect(delay: 750.ms, duration: 1500.ms).slideX(begin: 1)
                         .flipH(begin: -1, alignment: Alignment.centerRight)
                         .scaleXY(begin: 0.75, curve: Curves.easeInOutQuad)
                         .untint(begin: 0.6),
                    ),),

                  //                 ClipRRect(
    //                             borderRadius: BorderRadius.circular(20),
    //                             child: Image.asset(
    //                               fit: BoxFit.cover,
    //                               "assets/images/app-icon.png",
    //                               height: 400,
    //                               width: 400,
    //                             ).animate()
    //                                 .fadeIn(duration: 600.ms)
    //                                 .then(delay: 200.ms) // baseline=800ms
    //                                 .slide(),
    //                           ),


                               // ClipRRect(
                               //  borderRadius: BorderRadius.circular(20),
                               //  child: Image.asset(
                               //    fit: BoxFit.cover,
                               //    "assets/images/app-icon.png",
                               //    height: 400,
                               //    width: 400,
                               //  ).animate(onPlay: (controller) => controller.repeat())
                               //      .effect(duration: 3000.ms) // this "pads out" the total duration
                               //      .effect(delay: 750.ms, duration: 1500.ms).slideX(begin: 1)
                               //      .flipH(begin: -1, alignment: Alignment.centerRight)
                               //      .scaleXY(begin: 0.75, curve: Curves.easeInOutQuad)
                               //      .untint(begin: 0.6),
                               // ),
                              ),

            // SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
