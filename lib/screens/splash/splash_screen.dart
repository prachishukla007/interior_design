import 'package:flutter/material.dart';
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

class _SplashScreenState extends State<SplashScreen> {
  getItems() async {
    await context.read<HomeViewModel>().loadItemsData();

    appNavigator.pushReplacementNamed(Routes.wrapper);
  }

  @override
  void initState() {
    super.initState();
    getItems();
  }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300, // Increased width to accommodate even larger logo
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Center(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "assets/images/logo-main.jpeg",
                            height: 200,
                            // Increased height for the even larger logo
                            width:
                                200, // Increased width for the even larger logo
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
